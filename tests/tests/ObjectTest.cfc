component extends="testbox.system.BaseSpec"{

/*********************************** LIFE CYCLE Methods ***********************************/

	// executes before all suites+specs in the run() method
	function beforeAll(){}

	// executes after all suites+specs in the run() method
	function afterAll(){}

/*********************************** BDD SUITES ***********************************/

	function run(){
		describe( "getObjectName", function(){

			it( "should return the configured name of the object", function(){
				var obj = getObject( objectName="test_object" );

				expect( obj.getObjectName() ).toBe( "test_object" );
			} );

		} );

		describe( "listAttributes()", function(){

			it( "should return an array of attribute names defined on the object", function(){
				var attributes             = StructNew( "linked" );
				    attributes.test        = "value";
				    attributes.test2       = "value2";
				    attributes.anothertest = "anothervalue";

				var obj = getObject( attributes=attributes );

				expect( obj.listAttributes() ).tobe( [ "test", "test2", "anothertest" ] );
			} );

		} );

		describe( "attributeExists()", function(){

			it( "should return false when the attribute does not exist", function(){
				var obj = getObject();

				expect( obj.attributeExists( "nonexistant" ) ).tobe( false );
			} );

			it( "should return true when the attribute exists", function(){
				var obj = getObject( attributes={ foo="bar", labelfield="label" } );

				expect( obj.attributeExists( "labelfield" ) ).tobe( true );
			} );

		} );

		describe( "getAttribute()", function(){

			it( "should return an empty string when attribute does not exist and no default passed", function(){
				var obj = getObject();

				expect( obj.getAttribute( "nonexistant" ) ).tobe( "" );
			} );

			it( "should return passed default value when attribute does not exist", function(){
				var obj = getObject();

				expect( obj.getAttribute( "nonexistant", true ) ).tobe( true );
			} );

			it( "should return value of passed attribute when attribute exists", function(){
				var obj = getObject( attributes={ foo="bar", labelfield="label" } );

				expect( obj.getAttribute( "foo" ) ).tobe( "bar" );
			} );
		} );

		describe( "listProperties", function(){

			it( "should return an array of properties defined on the object", function(){
				var obj = getObject( properties=[ { name="prop1", type="boolean" }, { name="prop2" }, { name="another_prop" } ] );

				expect( obj.listProperties() ).toBe( [ "prop1", "prop2", "another_prop" ] );
			} );

		} );

		describe( "propertyExists()", function(){

			it( "should return false when the given property does not exist", function(){
				var obj = getObject();

				expect( obj.propertyExists( "nonexistant" ) ).tobe( false );
			} );

			it( "should return true when the given property exists", function(){
				var obj = getObject( properties=[ { name="prop1" }, { name="prop2" } ] );

				expect( obj.propertyExists( "prop1" ) ).tobe( true );
			} );

		} );

		describe( "getProperty()", function(){

			it( "should throw an informative error when the property does not exist", function(){
				var obj = getObject();

				expect( function(){
					obj.getProperty( "someproperty" );
				} ).toThrow( "presidedataobjects.object.propertynotfound" );
			} );

			it( "should return the property that matches the passed property name", function(){
				var obj = getObject( properties=[ { name="prop1", type="boolean" }, { name="prop2" } ] );

				expect( obj.getProperty( "prop1" ) ).tobe( { name="prop1", type="boolean" } );
			} );

		} );

		describe( "Missing methods", function(){
			it( "should be attempted to be called on the framework with the objectName appended to arguments", function(){
				var obj = getObject( objectName="my_object" );

				mockFramework.$( "selectData", QueryNew( '' ) );

				expect( obj.selectData( id="test" ) ).toBe( QueryNew( '' ) );
				var log = mockFramework.$callLog().selectData;
				expect( log.len() ).toBe( 1 );
				expect( log[1] ).toBe( { id="test", objectName="my_object" } )
			} );
		} );

		describe( "getTableName()", function(){

			it( "should return concatenated table prefix and tablename attributes", function(){
				var obj = getObject( attributes={ tablename="some_object", tableprefix="ptest_" } );

				expect( obj.getTableName() ).toBe( "ptest_some_object" );
			} );

			it( "should return default of pobj_(objectname) when no attributes for tablename and tableprefix explicitly set", function(){
				var obj = getObject( objectName="thisistest" );

				expect( obj.getTableName() ).toBe( "pobj_thisistest" );

			} );
		} );

	}

/*********************************** PRIVATE HELPERS ***********************************/

	private any function getObject( string objectname="some_object" ) {
		variables.mockFramework = getMockBox().createStub();

		return new presidedataobjects.library.Object( argumentCollection=arguments, framework=mockFramework );
	}
}
