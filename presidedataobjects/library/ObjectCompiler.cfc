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
		_setDefaultsInjector( new DefaultsInjector() );

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

		_injectDefaults( obj );

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

		var obj = new Object(
			  framework  = _getFramework()
			, objectName = arguments.objectName
			, attributes = arguments.attributes
			, properties = arguments.properties
		);
		_injectDefaults( obj );

		return obj;
	}

// PRIVATE HELPERS
	private void function _injectDefaults( required Object obj ) {
		var injector   = _getDefaultsInjector();
		var properties = obj.getProperties();
		var attributes = obj.getAttributes();

		injector.injectDefaultAttributes( attributes=attributes, objectName=obj.getObjectName() );
		injector.injectDefaultProperties( properties=properties, objectName=obj.getObjectName() );
		for( var propertyName in properties ){
			injector.injectDefaultPropertyAttributes( property=properties[ propertyName ], objectName=obj.getObjectName() );
		}
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

	private any function _getDefaultsInjector() {
		return _defaultsInjector;
	}
	private void function _setDefaultsInjector( required any defaultsInjector ) {
		_defaultsInjector = arguments.defaultsInjector;
	}

}