/**
 * Class that provides methods for keeping a database in sync
 * with an object library
 *
 */
 component {

// CONSTRUCTOR
	public any function init( required any sqlRunner, required any schemaVersioningService ) {
		_setSqlRunner( arguments.sqlRunner );
		_setSchemaVersioningService( arguments.schemaVersioningService );

		return this;
	}

// PUBLIC API
	public void function syncSchema( required any objectLibrary ) {
		if ( !_getSchemaVersioningService().hasDbVersionChanged( objectLibrary=arguments.objectLibrary ) ) {
			return;
		}

		_getSqlRunner().runSql( "some sql just to make a test fail should it hit here (still a lot of work to be done)" );
	}

// GETTERS AND SETTERS
	private any function _getSqlRunner() {
		return _sqlRunner;
	}
	private void function _setSqlRunner( required any sqlRunner ) {
		_sqlRunner = arguments.sqlRunner;
	}

	private any function _getSchemaVersioningService() {
		return _schemaVersioningService;
	}
	private void function _setSchemaVersioningService( required any schemaVersioningService ) {
		_schemaVersioningService = arguments.schemaVersioningService;
	}
}