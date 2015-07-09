/**
 * Class that provides logic for calculating the relationship between objects based
 * on their properties and other relationship features such as auto creating pivot tables
 *
 */
component {

	/**
	 * Method to create automatic pivot objects based on relationship
	 * data in existing objects
	 *
	 * @objects.hint  Structure of existing objects
	 * @compiler.hint Object that provides compiling capabilities
	 *
	 */
	public void function createAutoPivotObjects( required struct objects, required any compiler ) {
		var missingObjects = _getMissingPivotObjects( arguments.objects );
		for( var objectName in missingObjects ) {
			var meta = _getAutoPivotObjectMeta( missingObjects[ objectName ] );
			objects[ objectName ] = compiler.compileDynamicObject(
				  objectName = objectName
				, properties = meta.properties
				, attributes = meta.attributes
			);
		}
	}


// PRIVATE HELPERS
	private struct function _getMissingPivotObjects( required struct objects ) {
		var missingObjects = {};

		for( var objectName in objects ){
			var properties = objects[ objectName ].getProperties();
			for( var propertyName in properties ) {
				var property = properties[ propertyName ];
				if ( ( property.relationship ?: "" ) == "many-to-many" ) {
					var relatedVia = Trim( property.relatedVia ?: "" );

					if ( relatedVia.len() && !objects.keyExists( relatedVia ) ) {
						var isSource  = IsBoolean( property.relationshipIsSource ?: "" ) && property.relationshipIsSource;
						var relatedTo = property.relatedTo ?: "";

						missingObjects[ relatedVia ] = {
							  sourceObject = isSource ? objectName : relatedTo
							, targetObject = isSource ? relatedTo  : objectName
							, sourceFk     = property.relatedViaSourceFk ?: ""
							, targetFk     = property.relatedViaTargetFk ?: ""
						};
					}
				}
			}
		}

		return missingObjects;
	}

	private struct function _getAutoPivotObjectMeta( required struct relationshipInfo ) {
		return {
			  attributes = {}
			, properties  = [
				  { name=relationshipInfo.sourceFk, relationship="many-to-one", relatedTo=relationshipInfo.sourceObject, required=true, onDelete="cascade" }
				, { name=relationshipInfo.targetFk, relationship="many-to-one", relatedTo=relationshipInfo.targetObject, required=true, onDelete="cascade" }
				, { name="sort_order", type="numeric", dbtype="int", required=false }
			]
		}
	}

	public struct function getAutoPivotObjectDefinition( required struct sourceObject, required struct targetObject, required string pivotObjectName, required string sourcePropertyName, required string targetPropertyName ) output=false {
		var tmp = "";
		var autoObject = "";
		var objAName = LCase( ListLast( sourceObject.name, "." ) );
		var objBName = LCase( ListLast( targetObject.name, "." ) );
		var fieldOrder = ( sourcePropertyName < targetPropertyName ) ? "#sourcePropertyName#,#targetPropertyName#" : "#targetPropertyName#,#sourcePropertyName#";

		autoObject = {
			  dbFieldList = "#fieldOrder#,sort_order"
			, dsn         = sourceObject.dsn
			, indexes     = { "ux_#pivotObjectName#" = { unique=true, fields="#fieldOrder#" } }
			, name        = pivotObjectName
			, tableName   = LCase( sourceObject.tablePrefix & pivotObjectName )
			, tablePrefix = sourceObject.tablePrefix
			, versioned   = ( ( sourceObject.versioned ?: false ) || ( targetObject.versioned ?: false ) )
			, properties  = {
				  "#sourcePropertyName#" = new Property( name=sourcePropertyName, control="auto", type=sourceObject.properties.id.type, dbtype=sourceObject.properties.id.dbtype, maxLength=sourceObject.properties.id.maxLength, generator="none", relationship="many-to-one", relatedTo=objAName, required=true, onDelete="cascade" )
				, "#targetPropertyName#" = new Property( name=targetPropertyName, control="auto", type=targetObject.properties.id.type, dbtype=targetObject.properties.id.dbtype, maxLength=targetObject.properties.id.maxLength, generator="none", relationship="many-to-one", relatedTo=objBName, required=true, onDelete="cascade" )
				, "sort_order"           = new Property( name="sort_order"      , control="auto", type="numeric"                      , dbtype="int"                            , maxLength=0                                   , generator="none", relationship="none"                           , required=false )
			  }
		};

		return autoObject;
	}

}