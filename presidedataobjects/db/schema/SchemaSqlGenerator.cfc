/**
 * Class that provides methods for generating
 * SQL that creates or alters the database schema
 *
 */
component {

// CONSTRUCTOR
	public any function init( required any dbAdapter ){
		_setDbAdapter( arguments.dbAdapter );

		return this;
	}

// PUBLIC API
	public string function getColumnDefinitionSqlFromObjectProperty( required struct property ) {
		return _getDbAdapter().getColumnDefinitionSql(
			  columnName    = arguments.property.name   ?: ""
			, dbType        = arguments.property.dbType ?: "varchar"
			, maxLength     = Val( arguments.property.maxLength ?: 0 )
			, nullable      = !( IsBoolean( arguments.property.required ?: "" ) && arguments.property.required )
			, primaryKey    = IsBoolean( arguments.property.pk ?: "" ) && arguments.property.pk
			, autoIncrement = ( arguments.property.generator ?: "" ) == "increment"
		);
	}


// GETTERS AND SETTERS
	private any function _getDbAdapter() {
		return _dbAdapter;
	}
	private void function _setDbAdapter( required any dbAdapter ) {
		_dbAdapter = arguments.dbAdapter;
	}
}