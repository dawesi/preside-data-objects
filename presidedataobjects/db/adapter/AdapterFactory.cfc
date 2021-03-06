/**
 * Class that provides logic for returning Database
 * adapter objects for datasources
 *
 */
component {

	/**
	 * Constructor
	 */
	public any function init( required any dbInfoService ) {
		_setDbInfoService( arguments.dbInfoService );
		_setAdapters( {} )

		return this;
	}

	/**
	 * Gets the appropriate database adapter for the given
	 * DSN.
	 *
	 * @dsn.hint Datasource name for which to get the adapter
	 *
	 */
	public any function getAdapter( required string dsn ){
		var adapters = _getAdapters();

		if ( !adapters.keyExists( arguments.dsn ) ) {
			dbType = _getDbType( dsn = arguments.dsn );

			switch( dbType ) {
				case "MySql":
					adapters[ arguments.dsn ] = new MySqlAdapter();
				break;

				default:
					throw( type="PresideObjects.databaseEngineNotSupported", message="The database engine, [#dbType#], is not supported by the PresideObjects engine at this time" );
			}
		}

		return adapters[ arguments.dsn ];
	}

// PRIVATE HELPERS
	private string function _getDbType( required string dsn ){
		var db = QueryNew('');

		try {
			db = _getDbInfoService().getDatabaseVersion( arguments.dsn );

		} catch ( any e ) {}

		if ( not db.recordCount ) {
			throw( type="PresideObjects.datasourceNotFound", message="Datasource, [#arguments.dsn#], not found." );
		}

		return db.database_productname;
	}

// GETTERS AND SETTERS
	private any function _getDbInfoService(){
		return _dbInfoService;
	}
	private void function _setDbInfoService( required any dbInfoService ){
		_dbInfoService = arguments.dbInfoService;
	}

	private any function _getAdapters(){
		return _adapters;
	}
	private void function _setAdapters( required any adapters ){
		_adapters = arguments.adapters;
	}

}