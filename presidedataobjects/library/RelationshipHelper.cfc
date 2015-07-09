/**
 * Class that provides logic for calculating the relationship between objects based
 * on their properties and other relationship features such as auto creating pivot tables
 *
 */
component {

	/**
	 * Method that returns an array of all the pivot objects
	 * that do not exist in the passed library of objects.
	 *
	 * This list can then be used to automatically generate these objects,
	 * for example.
	 *
	 * @objects.hint Structure containing data objects, keys are object names - values are the objects themselves
	 */
	public array function listMissingPivotObjects( required struct objects ) {
		var missingObjects = {};

		for( var objectName in objects ){
			var properties = objects[ objectName ].getProperties();
			for( var propertyName in properties ) {
				var property = properties[ propertyName ];
				if ( ( property.relationship ?: "" ) == "many-to-many" ) {
					var relatedVia = Trim( property.relatedVia ?: "" );

					if ( relatedVia.len() && !objects.keyExists( relatedVia ) ) {
						missingObjects[ relatedVia ] = 1;
					}
				}
			}
		}

		return missingObjects.keyArray();
	}


	/**
	 * Method that takes a collection of data objects
	 * and returns a structure that represents their relationships
	 *
	 * @objects.hint Structure containing data objects, keys are object names - values are the objects themselves
	 *
	 */
	public struct function calculateRelationships( required struct objects ) {
		return {};
	}



}