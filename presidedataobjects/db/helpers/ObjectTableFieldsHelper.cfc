/**
 * Class that provides methods for helping with
 * the business of mapping preside data object
 * properties to database fields
 *
 */
component {

	variables._cachedTableFields = {};

	/**
	 * Returns an array of table fieldnames based
	 * on the defined properties of the object
	 *
	 */
	public array function listTableFields( required any object ) {
		var objectName = arguments.object.getName();

		if ( !_cachedTableFields.keyExists( objectName ) ) {
			var properties           = object.getProperties();
			var tableFields          = [];
			var ignoredRelationships = [ "many-to-many", "one-to-many" ];

			for( var propertyName in properties ) {
				if ( ignoredRelationships.findNoCase( properties[ propertyName ].relationship ?: "" ) ) {
					continue;
				}
				if ( ( properties[ propertyName ].dbtype ?: "" ) == "none" ) {
					continue;
				}

				tableFields.append( propertyName );
			}

			_cachedTableFields[ objectName ] = tableFields;
		}

		return _cachedTableFields[ objectName ];
	}
}