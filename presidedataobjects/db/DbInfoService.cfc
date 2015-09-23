/**
 * Proxy to cfdbinfo for returning information about a database and its objects
 *
 */
component extends="presidedataobjects.util.Base" {

// CONSTRUCTOR
	public any function init() {
		return this;
	}

// PUBLIC API METHODS
	public query function getDatabaseVersion( required string dsn ) {
		return _dbinfo( datasource=arguments.dsn, type="version" );
	}

	public array function listTables( required string dsn ) {
		var cacheKey = "listTables" & SerializeJson( arguments );
		return _localCache( cacheKey, function(){
			var tables = _dbinfo( datasource=arguments.dsn, type="tables" );

			return tables.recordCount ? ValueArray( tables.table_name ) : [];
		}, arguments );
	}

	public query function getTableInfo( required string tableName, required string dsn ) {
		var cacheKey = "getTableInfo" & SerializeJson( arguments );

		return _localCache( cacheKey, function(){
			return _dbInfo( datasource=arguments.dsn, type="tables", pattern=arguments.tableName );
		}, arguments );
	}

	public query function getTableColumns( required string tableName, required string dsn ) {
		var cacheKey = "getTableColumns" & SerializeJson( arguments );

		return _localCache( cacheKey, function(){
			return _dbInfo( datasource=arguments.dsn, type="columns", table=arguments.tableName );
		}, arguments );
	}

	public struct function getTableIndexes( required string tableName, required string dsn ) {
		var cacheKey = "getTableIndexes" & SerializeJson( arguments );

		return _localCache( cacheKey, function(){
			var rawIndexes       = _dbinfo( datasource=arguments.dsn, type="index", table=arguments.tableName );
			var convertedIndexes = {};

			for( var index in rawIndexes ){
				if ( index.index_name neq "PRIMARY" ) {
					convertedIndexes[ index.index_name ] = convertedIndexes[ index.index_name ] ?: {
						  unique = !index.non_unique
						, fields = []
					}

					convertedIndexes[ index.index_name ].fields.append( index.column_name );
				}
			}

			return convertedIndexes;
		}, arguments );
	}

	public struct function getTableForeignKeys( required string tableName, required string dsn ) {
		var cacheKey = "getTableIndexes" & SerializeJson( arguments );

		return _localCache( cacheKey, function(){
			var keys        = "";
			var key         = "";
			var constraints = {};
			var rules       = {};

			rules["0"] = "cascade";
			rules["2"] = "set null";

			dbinfo type="foreignKeys" table=arguments.tableName datasource="#arguments.dsn#" name="keys";
			for( key in keys ){
				constraints[ key.fk_name ] = {
					  pk_table  = key.pktable_name
					, fk_table  = key.fktable_name
					, pk_column = key.pkcolumn_name
					, fk_column = key.fkcolumn_name
				}

				if ( StructKeyExists( rules, key.update_rule ) ) {
					constraints[ key.fk_name ].on_update = rules[ key.update_rule ];
				} else {
					constraints[ key.fk_name ].on_update = "error";
				}

				if ( StructKeyExists( rules, key.delete_rule ) ) {
					constraints[ key.fk_name ].on_delete = rules[ key.delete_rule ];
				} else {
					constraints[ key.fk_name ].on_delete = "error";
				}
			}

			return constraints;
		}, arguments );
	}

	public boolean function tableExists( required string tableName, required string dsn ) {
		return listTables( dsn=arguments.dsn ).findnocase( arguments.tableName ) > 0;
	}

// PRIVATE HELPERS
	private query function _dbinfo( required string datasource, required string type ) {
		var dbInfoResult = "";

		dbinfo name                = "dbInfoResult"
		       datasource          = arguments.datasource
		       type                = arguments.type
		       attributeCollection = arguments;

		return dbInfoResult;
	}
}