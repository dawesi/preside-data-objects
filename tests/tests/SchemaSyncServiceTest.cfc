component extends="testbox.system.BaseSpec"{

/*********************************** LIFE CYCLE Methods ***********************************/

	// executes before all suites+specs in the run() method
	function beforeAll(){
	}

	// executes after all suites+specs in the run() method
	function afterAll(){}

/*********************************** BDD SUITES ***********************************/

	function run(){
		describe( "listChanges", function(){
			it( "should return an empty changeset when the version in the database has not changed", function(){
				var syncService = _getSyncService();
				var mockLibrary = getMockBox().createEmptyMock( "presidedataobjects.library.ObjectLibrary" );

				mockVersioningService.$( "hasDbVersionChanged" ).$args( objectLibrary=mockLibrary ).$results( false );

				expect( syncService.listChanges( objectLibrary=mockLibrary ) ).toBe( {} );
			} );

			it( "should return a struct whos keys are the names of objects that have changed and who's values are an array of field names that have changed", function(){
				var syncService = _getSyncService();
				var mockLibrary = getMockBox().createEmptyMock( "presidedataobjects.library.ObjectLibrary" );
				var objects     = {
					  object_a = { changed=true , mockObject=getMockBox().createEmptyMock( className="presidedataobjects.library.Object", callLogging=false ), fields=[ { name="field1", changed=false }, { name="field2", changed=true  }, { name="field3", changed=true }  ] }
					, object_b = { changed=false, mockObject=getMockBox().createEmptyMock( className="presidedataobjects.library.Object", callLogging=false ), fields=[ { name="field1", changed=false }, { name="field2", changed=false }, { name="field3", changed=false }  ] }
					, object_c = { changed=true , mockObject=getMockBox().createEmptyMock( className="presidedataobjects.library.Object", callLogging=false ), fields=[ { name="field1", changed=true  }, { name="field2", changed=false }, { name="field3", changed=true }  ] }
				};
				var expected = {
					  object_a = [ "field2", "field3" ]
					, object_c = [ "field1", "field3" ]
				};

				mockLibrary.$( "listObjects", objects.keyArray() );
				for( var objName in objects ) {
					objects[ objName ].mockObject.$( "listProperties", [ "field1", "field2", "field3" ] );
					for( var field in objects[ objName ].fields ) {
						objects[ objName ].mockObject.$( "getProperty" ).$args( propertyName=field.name ).$results( field );
					}
				}

				for( var objName in objects ) {
					mockLibrary.$( "getObject" ).$args( objectName=objName ).$results( objects[ objName ].mockObject );
					mockVersioningService.$( "hasObjectVersionChanged" ).$args( object=objects[ objName ].mockObject ).$results( objects[ objName ].changed );
					for( var field in objects[ objName ].fields ) {
						mockVersioningService.$( "hasFieldVersionChanged" ).$args( field=field, object=objects[ objName ].mockObject ).$results( field.changed );
					}
				}
				mockVersioningService.$( "hasDbVersionChanged" ).$args( objectLibrary=mockLibrary ).$results( true );

				// waiting on bug with Testbox to be fixed (TESTBOX-134) before this test can be run
				// expect( syncService.listChanges( objectLibrary=mockLibrary ) ).toBe( expected );
			} );
		} );
	}

/*********************************** PRIVATE HELPERS ***********************************/
	private function _getSyncService() {
		variables.mockdsn               = "testdsn";
		variables.mockVersioningService = getMockBox().createEmptyMock( "presidedataobjects.db.schema.SchemaVersioningService" );
		variables.mockDbInfoService     = getMockBox().createEmptyMock( "presidedataobjects.db.DbInfoService" );
		variables.mockSqlAdapter        = getMockBox().createStub();
		variables.mockAdapterFactory    = getMockBox().createEmptyMock( "presidedataobjects.db.adapter.AdapterFactory" );
		variables.mockSqlRunner         = getMockBox().createEmptyMock( "presidedataobjects.db.SqlRunner" );
		variables.mockSchemaGenerator   = getMockBox().createStub();
		variables.mockTableFieldsHelper = getMockBox().createEmptyMock( "presidedataobjects.db.helpers.ObjectTableFieldsHelper" );
		variables.mockAdapterFactory.$( "getAdapter" ).$args( dsn=mockDsn ).$results( mockSqlAdapter );



		return getMockBox().createMock(
			object = new presidedataobjects.db.schema.SchemaSyncService(
				  dsn                     = mockdsn
				, dbInfoService           = mockDbInfoService
				, adapterFactory          = mockAdapterFactory
				, sqlRunner               = mockSqlRunner
				, schemaGenerator         = mockSchemaGenerator
				, schemaVersioningService = mockVersioningService
				, objectTableFieldsHelper = mockTableFieldsHelper
			)
		);
	}
}
