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
		,          string versionTableName = "_preside_generated_entity_versions"
 	) {
 		_setDsn( arguments.dsn );
 		_setDbInfoService( arguments.dbInfoService );
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

// PRIVATE HELPERS

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

	private string function _getVersionTableName() {
		return _versionTableName;
	}
	private void function _setVersionTableName( required string versionTableName ) {
		_versionTableName = arguments.versionTableName;
	}
 }