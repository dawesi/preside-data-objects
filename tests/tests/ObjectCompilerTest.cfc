component extends="testbox.system.BaseSpec"{

/*********************************** LIFE CYCLE Methods ***********************************/

	// executes before all suites+specs in the run() method
	function beforeAll(){}

	// executes after all suites+specs in the run() method
	function afterAll(){}

/*********************************** BDD SUITES ***********************************/

	function run(){
		var mockFramework = getMockbox().createStub();
		var compiler = new presidedataobjects.library.ObjectCompiler( framework=mockFramework );

		describe( "compileObject()", function(){
			it( "should take an objectname and set of source paths and convert it into a single compiled object instance", function(){
				var sourceFiles    = [ "/resources/objectcompiler/object_a.cfc", "/resources/objectcompiler/object_b.cfc", "/resources/objectcompiler/object_c.cfc" ];
				var objectName     = "my_object";
				var compiledObject = compiler.compileObject( objectName=objectName, sourceFiles=sourceFiles );

				expect( compiledObject.getObjectName() ).toBe( objectName );
				expect( compiledObject.testMethodsWorking() ).toBe( true );
				expect( compiledObject.listAttributes() ).toBe( [ "datamanager", "labelfield" ] );
				expect( compiledObject.getAttribute( "labelfield" ) ).toBe( "code" );
				expect( compiledObject.getAttribute( "datamanager" ) ).toBe( true );
				expect( compiledObject.listProperties() ).toBe( [ "label", "code" ] );
				expect( compiledObject.getProperty( "label" ) ).toBe( { name="label", type="string", dbtype="varchar", maxlength=255, uniqueindexes="label", required=true } );

				mockFramework.$( "selectData", QueryNew( 'test,this,stuff' ) );
				expect( compiledObject.selectData() ).toBe( QueryNew( 'test,this,stuff' ) );
			} );
		} );

		describe( "compileDynamicObject", function(){
			it( "should take an objectname, and set of porperties and attributes, and return a compiled preside data object", function(){
				var objectName     = "some_object";
				var attributes     = { datamanager=true, labelfield="label" };
				var properties     = [ { name="label", required=true } ];
				var compiledObject = compiler.compileDynamicObject( objectName=objectName, attributes=attributes, properties=properties );

				expect( compiledObject.getObjectName() ).toBe( objectName );
				expect( compiledObject.listAttributes() ).toBe( [ "datamanager", "dynamic", "labelfield" ] );
				expect( compiledObject.getAttribute( "labelfield" ) ).toBe( "label" );
				expect( compiledObject.listProperties() ).toBe( [ "label" ] );
				expect( compiledObject.getProperty( "label" ) ).toBe( properties[1] );

				mockFramework.$( "selectData", QueryNew( 'test,this,stuff' ) );
				expect( compiledObject.selectData() ).toBe( QueryNew( 'test,this,stuff' ) );
			} );

			it( "should add a 'dynamic=true' attribute to the object", function(){
				var objectName     = "some_object";
				var attributes     = { datamanager=true, labelfield="label" };
				var properties     = [ { name="label", required=true } ];
				var compiledObject = compiler.compileDynamicObject( objectName=objectName, attributes=attributes, properties=properties );

				expect( compiledObject.getAttribute( "dynamic", false ) ).toBe( true );
			} );
		} );
	}

/*********************************** PRIVATE HELPERS ***********************************/

}
