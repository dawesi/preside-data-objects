/**
 * Class to provide logic for producing fully ready and 'compiled' preside data objects.
 * This means objects that have all their properties, attributes and methods merged
 * and any default and calculated properties/attributes added to them
 *
 */
component {

// CONSTRUCTOR
	public any function init( required any framework ) {
		_setFramework( arguments.framework );
		_setMetaReader( new ObjectMetaReader() );
		_setObjectMerger( new ObjectMerger() );

		return this;
	}

// PUBLIC API
	/**
	 * Compiles an object from its source files
	 *
	 * @objectName.hint  The name of the object
	 * @sourceFiles.hint Array of mapped paths to source files for the object
	 *
	 */
	public Object function compileObject( required string objectName, required array sourceFiles ) {
		var meta = _getMetaReader().readMeta( arguments.sourceFiles );
		var obj  = new Object(
			  framework  = _getFramework()
			, objectName = arguments.objectName
			, attributes = meta.attributes ?: {}
			, properties = meta.properties ?: []
		);

		for( var sourceFile in arguments.sourceFiles ) {
			var objectPath = Replace( ReReplace( sourceFile, "^/(.*?)\.cfc$", "\1" ), "/", ".", "all" );
			_getObjectMerger().mergeObjects( targetObject=obj, objectToMerge=new "#objectPath#"() );
		}

		return obj;
	}

	/**
	 * Compiles an object based on dynamically generated attributes and properties
	 *
	 * @objectName.hint The name of the object
	 * @properties.hint Array of properties for the object
	 * @attributes.hint Structure of attributes for the object
	 *
	 */
	public Object function compileDynamicObject( required string objectName, required array properties, required struct attributes ) {
		arguments.attributes.dynamic = true;

		return new Object(
			  framework  = _getFramework()
			, objectName = arguments.objectName
			, attributes = arguments.attributes
			, properties = arguments.properties
		);
	}

// GETTERS AND SETTERS
	private any function _getFramework() {
		return _framework;
	}
	private void function _setFramework( required any framework ) {
		_framework = arguments.framework;
	}

	private ObjectMetaReader function _getMetaReader() {
		return _metaReader;
	}
	private void function _setMetaReader( required ObjectMetaReader metaReader ) {
		_metaReader = arguments.metaReader;
	}

	private any function _getObjectMerger() {
		return _objectMerger;
	}
	private void function _setObjectMerger( required any objectMerger ) {
		_objectMerger = arguments.objectMerger;
	}

}