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
	public struct function listChanges( required any objectLibrary ) {
		var versioningService = _getSchemaVersioningService();

		if ( !versioningService.hasDbVersionChanged( objectLibrary=arguments.objectLibrary ) ) {
			return {};
		}

		var changes = {};
		for( var objectName in objectLibrary.listObjects() ) {
			var object = objectLibrary.getObject( objectName=objectName );
			if ( versioningService.hasObjectVersionChanged( object=object ) ) {
				changes[ objectName ] = [];
				var fields = object.listProperties();
				for( var fieldname in fields ) {
					var field = object.getProperty( propertyName=fieldname );
					if ( versioningService.hasFieldVersionChanged( field=field, object=object ) ) {
						changes[ objectName ].append( fieldname );
					}
				}
			}
		}

		return changes;
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