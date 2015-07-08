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
	public string function getObjectName() {
		return _getObjectName();
	}

	public array function listAttributes() {
		return _getAttributes().keyArray();
	}

	public boolean function attributeExists( required string attributeName ) {
		var attributes = _getAttributes();
		return attributes.keyExists( arguments.attributeName );
	}

	public any function getAttribute( required string attributeName, any defaultValue="" ) {
		var attributes = _getAttributes();

		return attributes[ arguments.attributeName ] ?: arguments.defaultValue;
	}

	public array function listProperties() {
		return _getProperties().keyArray();
	}

	public boolean function propertyExists( required string propertyName ) {
		var properties = _getProperties();
		return properties.keyExists( arguments.propertyName );
	}

	public struct function getProperty( required string propertyName ) {
		var properties = _getProperties();

		return properties[ arguments.propertyName ] ?: throw( type="presidedataobjects.object.propertynotfound" );
	}

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