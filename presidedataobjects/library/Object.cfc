/**
 * Class that is used as a singleton *per* object defined
 * in the system. Provides methods for getting object
 * attributes and properties + proxies to framework
 * methods for interacting with the object itself.
 *
 */
component {

// CONSTRUCTOR
	public any function init( struct attributes={} ) {
		_setAttributes( arguments.attributes );
	}

// PUBLIC API
	public boolean function attributeExists( required string attributeName ) {
		var attributes = _getAttributes();
		return attributes.keyExists( arguments.attributeName );
	}

	public any function getAttribute( required string attributeName, any defaultValue="" ) {
		var attributes = _getAttributes();

		return attributes[ arguments.attributeName ] ?: arguments.defaultValue;
	}


// GETTERS AND SETTERS
	private struct function _getAttributes() {
		return _attributes;
	}
	private void function _setAttributes( required struct attributes ) {
		_attributes = arguments.attributes;
	}
}