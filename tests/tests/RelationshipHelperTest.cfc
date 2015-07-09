component extends="testbox.system.BaseSpec"{

/*********************************** LIFE CYCLE Methods ***********************************/

	// executes before all suites+specs in the run() method
	function beforeAll(){}

	// executes after all suites+specs in the run() method
	function afterAll(){}

/*********************************** BDD SUITES ***********************************/

	function run(){
		var helper = new presidedataobjects.library.RelationshipHelper();

		describe( "calculateRelationships()", function(){

			it( "should return an empty structure when passed an empty structure of objects", function(){
				expect( helper.calculateRelationships( objects={} ) ).toBe( {} );
			} );

			it( "should return an empty structure when no relationships exist between the objects", function(){
				var simpleProps = { id={ name="id", type="string" }, label={ name="label", type="string" } };
				var objects     = { object_a=getMockBox().createStub(), object_b=getMockBox().createStub() };

				objects.object_a.$( "listProperties", [ "id", "label" ] );
				objects.object_a.$( "getProperty" ).$args( propertyName="id" ).$results( simpleProps.id );
				objects.object_a.$( "getProperty" ).$args( propertyName="label" ).$results( simpleProps.label );
				objects.object_b.$( "listProperties", [ "id", "label" ] );
				objects.object_b.$( "getProperty" ).$args( propertyName="id" ).$results( simpleProps.id );
				objects.object_b.$( "getProperty" ).$args( propertyName="label" ).$results( simpleProps.label );

				expect( helper.calculateRelationships( objects=objects ) ).toBe( {} );
			} );

		} );

		describe( "listMissingPivotObjects", function(){

			it( "should return a list of many-to-many relatedVia objects that do not exist in the library of objects", function(){
				var objects = {
					  object_a = getMockbox().createStub()
					, object_b = getMockbox().createStub()
					, object_c = getMockbox().createStub()
					, object_d = getMockbox().createStub()
				};
				var object_a_props = { bs={ name="bs", relationship="many-to-many", relatedTo="object_b", relatedvia="nonexistantpivot" }, cs={ name="cs", relationship="many-to-many", relatedTo="object_c", relatedvia="pivottwo" } };
				var object_b_props = { as={ name="as", relationship="many-to-many", relatedTo="object_a", relatedvia="object_d" } };
				var object_c_props = { as={ name="as", relationship="many-to-many", relatedTo="object_a", relatedvia="pivottwo" } };
				var object_d_props = {};

				objects.object_a.$( "getProperties", object_a_props );
				objects.object_b.$( "getProperties", object_b_props );
				objects.object_c.$( "getProperties", object_c_props );
				objects.object_d.$( "getProperties", object_d_props );

				var missing = helper.listMissingPivotObjects( objects=objects );

				expect( missing.sort( "textnocase" ) ).toBe( [ "nonexistantpivot", "pivottwo" ] );

			} );

		} );
	}

}