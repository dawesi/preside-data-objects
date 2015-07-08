component extends="testbox.system.BaseSpec"{

/*********************************** LIFE CYCLE Methods ***********************************/

	// executes before all suites+specs in the run() method
	function beforeAll(){}

	// executes after all suites+specs in the run() method
	function afterAll(){}

/*********************************** BDD SUITES ***********************************/

	function run(){
		describe( "getAttribute()", function(){

			it( "should return an empty string when attribute does not exist and no default passed", function(){
				var obj = new presidedataobjects.library.Object();

				expect( obj.getAttribute( "nonexistant" ) ).tobe( "" );
			} );

			it( "should return passed default value when attribute does not exist", function(){
				var obj = new presidedataobjects.library.Object();

				expect( obj.getAttribute( "nonexistant", true ) ).tobe( true );
			} );

			it( "should return value of passed attribute when attribute exists", function(){
				var obj = new presidedataobjects.library.Object( attributes={ foo="bar", labelfield="label" } );

				expect( obj.getAttribute( "foo" ) ).tobe( "bar" );
			} );
		} );

		describe( "attributeExists()", function(){

			it( "should return false when the attribute does not exist", function(){
				var obj = new presidedataobjects.library.Object();

				expect( obj.attributeExists( "nonexistant" ) ).tobe( false );
			} );

			it( "should return true when the attribute exists", function(){
				var obj = new presidedataobjects.library.Object( attributes={ foo="bar", labelfield="label" } );

				expect( obj.attributeExists( "labelfield" ) ).tobe( true );
			} );

		} );

		describe( "propertyExists()", function(){

			it( "should return false when the given property does not exist", function(){
				var obj = new presidedataobjects.library.Object();

				expect( obj.propertyExists( "nonexistant" ) ).tobe( false );
			} );

			it( "should return true when the given property exists", function(){
				var obj = new presidedataobjects.library.Object( properties=[ { name="prop1" }, { name="prop2" } ] );

				expect( obj.propertyExists( "prop1" ) ).tobe( true );
			} );

		} );

		describe( "getProperty()", function(){

			it( "should throw an informative error when the property does not exist", function(){
				var obj = new presidedataobjects.library.Object();

				expect( function(){
					obj.getProperty( "someproperty" );
				} ).toThrow( "presidedataobjects.object.propertynotfound" );
			} );

		} );
	}
}
