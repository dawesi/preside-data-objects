/**
 * Class that adds default properties, property attributes
 * and object attributes to an object definition when
 * those defaults are missing
 *
 */
component {

	/**
	 * Method to inject default system properties
	 * into an object. These are id, datecreated and datemodified.
	 * If they don't exist already, they'll be added. If they do, their default attributes
	 * will be merged.
	 *
	 * @properties.hint Structure of existing properties
	 */
	public void function injectDefaultProperties( required struct properties ) {
		var defaultProperties = {
			  id           = { name="id"          , type="string", required=true, dbtype="varchar", maxLength=35, generator="UUID", pk=true }
			, datecreated  = { name="datecreated" , type="date"  , required=true, dbtype="datetime" }
			, datemodified = { name="datemodified", type="date"  , required=true, dbtype="datetime" }
		};

		for( var key in defaultProperties ){
			arguments.properties[ key ] = arguments.properties[ key ] ?: {};
			arguments.properties[ key ].append( defaultProperties[ key ], false );
		}
	}

	/**
	 * Method to inject various default attributes
	 * into properties dependent on other property attributes
	 *
	 */
	public void function injectDefaultPropertyAttributes( required struct property, required string objectName ) {
		var relationshipValues = [ "many-to-one", "many-to-many", "one-to-many" ];

		if ( relationshipValues.findNoCase( property.relationship ?: "" ) ) {
			_injectRelationshipPropertyAttributeDefaults( objectName=objectName, property=property  );
		} else {
			_injectDatabaseTypePropertyAttributeDefaults( property );
		}
	}

	/**
	 * Method to inject various default attributes
	 * into an objects attribute collection
	 *
	 */
	public void function injectDefaultAttributes( required struct attributes, required string objectName ) {
		attributes.tableName   = attributes.tableName   ?: objectName;
		attributes.tablePrefix = attributes.tablePrefix ?: "pobj_";
	}


// PRIVATE HELPERS
	private void function _injectDatabaseTypePropertyAttributeDefaults( required struct property ) {
		if ( ( property.type ?: "any" ) == "any" ) {
			property.type = "string";
		}

		switch( property.type ) {
			case "string":
				property.dbtype = property.dbtype ?: "varchar";
			break;

			case "numeric":
				property.dbtype = property.dbtype ?: "int";
			break;

			case "date":
				property.dbtype = property.dbtype ?: "datetime";
			break;

			case "boolean":
				property.dbtype = property.dbtype ?: "boolean";
			break;

			case "binary":
				property.dbtype = property.dbtype ?: "blob";
			break;
		}

		switch( property.dbtype ?: "" ) {
			case "varchar":
				property.maxlength = property.maxlength ?: 255;
			break;
		}
	}

	private void function _injectRelationshipPropertyAttributeDefaults( required string objectName, required struct property ) {
		property.relatedTo = property.relatedTo ?: ( property.name ?: "" );

		switch( property.relationship ?: "" ){
			case "many-to-many":
				property.relationshipIsSource = property.relationshipIsSource ?: true;
				property.relatedViaSourceFk   = property.relatedViaSourceFk   ?: objectName;
				property.relatedViaTargetFk   = property.relatedViaTargetFk   ?: property.relatedTo;
				property.relatedVia           = property.relatedVia           ?: ( objectName < property.relatedTo ? "#objectName#__join__#property.relatedTo#" : "#property.relatedTo#__join__#objectName#" );
			break;

			case "one-to-many":
				property.relationshipKey = property.relationshipKey ?: objectName;
			break;
		}
	}
}