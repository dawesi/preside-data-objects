/**
 * Class that provides methods for querying
 * and storing version information about the database tables
 * that have been generated from preside object definitions
 *
 * @singleton true
 *
 */
 component {

// CONSTRUCTOR
	public any function init(
		  required string dsn
		, required any    dbInfoService
		, required any    adapterFactory
		, required any    sqlRunner
		, required any    objectTableFieldsHelper
		,          string versionTableName = "_preside_generated_entity_versions"
	) {
		_setDsn( arguments.dsn );
		_setDbInfoService( arguments.dbInfoService );
		_setAdapterFactory( arguments.adapterFactory );
		_setSqlRunner( arguments.sqlRunner );
		_setObjectTableFieldsHelper( arguments.objectTableFieldsHelper );
		_setVersionTableName( arguments.versionTableName );

		return this;
	}

// PUBLIC API
	public boolean function versioningTableExists() {
		var tableInfo = _getDbInfoService().getTableInfo(
			  tableName = _getVersionTableName()
			, dsn       = _getDsn()
		);

		return tableInfo.recordCount > 0;
	}

	public any function createVersioningTable() {
		if ( !versioningTableExists() ) {
			var sqlStatements = getCreateVersioningTableSql();
			var runner        = _getSqlRunner();
			var dsn           = _getDsn();

			for( var sqlStatement in sqlStatements ) {
				runner.runSql( sql=sqlStatement, dsn=dsn );
			}
		}
	}

	/**
	 * Returns an array of SQL statements that can be used
	 * to create the schema versioning table
	 *
	 */
	public array function getCreateVersioningTableSql() {
		var adapter = _getAdapter();
		var tableSql = "";

		var columnDefs = adapter.getColumnDefinitionSql(
			  columnName = "entity_type"
			, dbType     = "varchar"
			, maxLength  = "10"
			, nullable   = false
		);
		columnDefs = ListAppend( columnDefs, adapter.getColumnDefinitionSql(
			  columnName = "entity_name"
			, dbType     = "varchar"
			, maxLength  = "200"
			, nullable   = false
		) );
		columnDefs = ListAppend( columnDefs, adapter.getColumnDefinitionSql(
			  columnName = "parent_entity_name"
			, dbType     = "varchar"
			, maxLength  = "200"
			, nullable   = true
		) );
		columnDefs = ListAppend( columnDefs, adapter.getColumnDefinitionSql(
			  columnName = "version_hash"
			, dbType     = "varchar"
			, maxLength  = "32"
			, nullable   = false
		) );
		columnDefs = ListAppend( columnDefs, adapter.getColumnDefinitionSql(
			  columnName = "date_modified"
			, dbType     = "timestamp"
			, nullable   = false
		) );

		var tableSql = adapter.getTableDefinitionSql(
			  tableName = _getVersionTableName()
			, columnSql = columnDefs
		);

		var indexSql = adapter.getIndexSql(
			  indexName = "ux_preside_generated_entity_versions"
			, tableName = _getVersionTableName()
			, fieldList = "entity_type,parent_entity_name,entity_name"
			, unique    = true
		);

		return [ tableSql, indexSql ];
	}

	public boolean function versionExists(
		  required string entityType
		, required string entityName
		,          string parentEntityName = ""
	) {
		var filter = _getVersionFilter( argumentCollection=arguments );
		var selectSql = _getAdapter().getSelectSql(
			  tableName     = _getVersionTableName()
			, selectColumns = [ "1" ]
			, filter        = filter.sql
		);
		var queryResult = _getSqlRunner().runSql(
			  sql    = selectSql
			, dsn    = _getDsn()
			, params = filter.params
		);

		return queryResult.recordCount > 0;
	}

	public string function getSaveVersionSql(
		  required string entityType
		, required string entityName
		, required string versionHash
		,          string parentEntityName = ""
	) {
		var todaySql = _getAdapter().getCurrentDateSql();

		if ( versionExists( entityType=arguments.entityType, entityName=arguments.entityName, parentEntityName=arguments.parentEntityName ) ) {
			var clauseSql = _getVersionFilter( argumentCollection=arguments, parametizedValues=false ).sql;

			return "update #_getVersionTableName()# set version_hash = '#arguments.versionHash#', date_modified = #todaySql# where #clauseSql#";
		} else {
			var parentEntityValue = arguments.parentEntityName.len() ? "'#arguments.parentEntityName#'" : 'null';
			return "insert into #_getVersionTableName()# ( entity_type, entity_name, parent_entity_name, version_hash, date_modified ) values ( '#arguments.entityType#', '#arguments.entityName#', #parentEntityValue#, '#arguments.versionHash#', #todaySql# )"

		}

		return "";
	}

	public void function saveVersion(
		  required string entityType
		, required string entityName
		, required string versionHash
		,          string parentEntityName = ""
	) {
		_getSqlRunner().runSql(
			  sql = getSaveVersionSql( argumentCollection=arguments )
			, dsn = _getDsn()
		);
	}

	public string function getFieldVersionHash( required struct field ) {
		return Hash( SerializeJson( arguments.field ) );
	}

	public string function getObjectVersionHash( required any object ) {
		var dbFields    = _getObjectTableFieldsHelper().listTableFields( object=arguments.object );
		var versionHash = "";

		for( var fieldName in dbFields ) {
			versionHash &= getFieldVersionHash( field=arguments.object.getProperty( propertyName=fieldName ) );
		}

		return Hash( versionHash );
	}

	public string function getDatabaseVersionHash( required any objectLibrary ) {
		var objectNames = arguments.objectLibrary.listObjects();
		var versionHash = "";

		for( var objectName in objectNames ){
			var object = arguments.objectLibrary.getObject( objectName=objectName );
			versionHash &= getObjectVersionHash( object=object );
		}

		return Hash( versionHash );
	}

// PRIVATE HELPERS
	private any function _getAdapter() {
		return _getAdapterFactory().getAdapter( dsn=_getDsn() );
	}

	private struct function _getVersionFilter(
		  required string  entityType
		, required string  entityName
		, required string  parentEntityName
		,          boolean parametizedValues = true
	) {
		var filterSql    = "";
		var filterParams = {};

		if ( arguments.parametizedValues ) {
			filterSql = "entity_type = :entity_type and entity_name = :entity_name and parent_entity_name ";
			filterParams = [
				  { name="entity_type"       , cfsqltype="varchar", value=arguments.entityType       }
				, { name="entity_name"       , cfsqltype="varchar", value=arguments.entityName       }
			];
		} else {
			filterSql = "entity_type = '#arguments.entityType#' and entity_name = '#arguments.entityName#' and parent_entity_name ";
		}

		if ( arguments.parentEntityName.len() ) {
			if ( arguments.parametizedValues ) {
				filterSql &= "= :parent_entity_name";
				filterParams.append( { name="parent_entity_name", cfsqltype="varchar", value=arguments.parentEntityName } );
			} else {
				filterSql &= "= '#arguments.parentEntityName#'";
			}
		} else {
			filterSql &= "is null";
		}

		return {
			  sql    = filterSql
			, params = filterParams
		};
	}

// GETTERS AND SETTERS
	private string function _getDsn() {
		return _dsn;
	}
	private void function _setDsn( required string dsn ) {
		_dsn = arguments.dsn;
	}

	private any function _getDbInfoService() {
		return _dbInfoService;
	}
	private void function _setDbInfoService( required any dbInfoService ) {
		_dbInfoService = arguments.dbInfoService;
	}

	private any function _getAdapterFactory() {
		return _adapterFactory;
	}
	private void function _setAdapterFactory( required any adapterFactory ) {
		_adapterFactory = arguments.adapterFactory;
	}

	private any function _getSqlRunner() {
		return _sqlRunner;
	}
	private void function _setSqlRunner( required any sqlRunner ) {
		_sqlRunner = arguments.sqlRunner;
	}

	private any function _getObjectTableFieldsHelper() {
		return _objectTableFieldsHelper;
	}
	private void function _setObjectTableFieldsHelper( required any objectTableFieldsHelper ) {
		_objectTableFieldsHelper = arguments.objectTableFieldsHelper;
	}

	private string function _getVersionTableName() {
		return _versionTableName;
	}
	private void function _setVersionTableName( required string versionTableName ) {
		_versionTableName = arguments.versionTableName;
	}
 }