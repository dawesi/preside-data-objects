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

}