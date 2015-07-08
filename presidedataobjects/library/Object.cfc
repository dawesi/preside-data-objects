/**
 * Class that is used as a singleton *per* object defined
 * in the system. Provides methods for getting object
 * attributes and properties + proxies to framework
 * methods for interacting with the object itself.
 *
 */
component {

// CONSTRUCTOR
	public any function init(
		  required string objectName
		, required any    framework
		,          struct attributes={}
		,          array properties=[]
	) {
		_setObjectName( arguments.objectName );
		_setFramework( arguments.framework );
		_setAttributes( arguments.attributes );
		_setProperties( arguments.properties );
	}

// PUBLIC API
	/**
	 * Returns the name of the object
	 *
	 */
	public string function getObjectName() {
		return _getObjectName();
	}

	/**
	 * Returns an array of attribute names that are defined
	 * on the object
	 *
	 */
	public array function listAttributes() {
		return _getAttributes().keyArray();
	}

	/**
	 * Returns whether or not the given attribute exists.
	 *
	 * @attributeName.hint The name of the attribute
	 */
	public boolean function attributeExists( required string attributeName ) {
		var attributes = _getAttributes();
		return attributes.keyExists( arguments.attributeName );
	}

	/**
	 * Returns the value of the given attribute or, if it does not exist, the value of
	 * the `defaultValue` argument.
	 *
	 * @attributeName.hint The name of the attribute
	 * @defaultValue.hint  Value to return should the given attribute not exist
	 */
	public any function getAttribute( required string attributeName, any defaultValue="" ) {
		var attributes = _getAttributes();

		return attributes[ arguments.attributeName ] ?: arguments.defaultValue;
	}

	/**
	 * Returns an array of the property names defined on the object
	 *
	 */
	public array function listProperties() {
		return _getProperties().keyArray();
	}

	/**
	 * Returns whether or not the given property exists
	 *
	 * @propertyName.hint The name of the property
	 *
	 */
	public boolean function propertyExists( required string propertyName ) {
		var properties = _getProperties();
		return properties.keyExists( arguments.propertyName );
	}

	/**
	 * Returns the given property. Throws a 'presidedataobjects.object.propertynotfound'
	 * error if the property does not exist.
	 *
	 * @propertyName.hint The name of the property
	 */
	public struct function getProperty( required string propertyName ) {
		var properties = _getProperties();

		return properties[ arguments.propertyName ] ?: throw( type="presidedataobjects.object.propertynotfound" );
	}


// UTILITY
	/**
	 * @autodoc false
	 */
	public any function onMissingMethod( required string methodName, required any methodArgs ) {
		var fw = _getFramework();

		return fw[ arguments.methodName ]( argumentCollection=arguments.methodArgs, objectName=_getObjectName() );
	}


// GETTERS AND SETTERS
	private string function _getObjectName() {
		return _objectName;
	}
	private void function _setObjectName( required string objectName ) {
		_objectName = arguments.objectName;
	}

	private struct function _getAttributes() {
		return _attributes;
	}
	private void function _setAttributes( required struct attributes ) {
		_attributes = arguments.attributes;
	}

	private struct function _getProperties() {
		return _properties;
	}
	private void function _setProperties( required array properties ) {
		_properties = StructNew( "linked" );

		for( var prop in arguments.properties ) {
			_properties[ prop.name ?: "" ] = prop;
		}
	}

	private any function _getFramework() {
		return _framework;
	}
	private void function _setFramework( required any framework ) {
		_framework = arguments.framework;
	}
}