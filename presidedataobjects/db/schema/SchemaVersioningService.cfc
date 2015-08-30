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
		,          string versionTableName = "_preside_generated_entity_versions"
	) {
		_setDsn( arguments.dsn );
		_setDbInfoService( arguments.dbInfoService );
		_setAdapterFactory( arguments.adapterFactory );
		_setSqlRunner( arguments.sqlRunner );
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

// PRIVATE HELPERS
	private any function _getAdapter() {
		return _getAdapterFactory().getAdapter( dsn=_getDsn() );
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

	private string function _getVersionTableName() {
		return _versionTableName;
	}
	private void function _setVersionTableName( required string versionTableName ) {
		_versionTableName = arguments.versionTableName;
	}
 }