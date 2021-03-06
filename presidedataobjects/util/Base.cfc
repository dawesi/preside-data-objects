component {

	private struct function _reSearch( required string regex, required string text ) {
		var final 	= StructNew();
		var pos		= 1;
		var result	= ReFindNoCase( arguments.regex, arguments.text, pos, true );
		var i		= 0;

		while( ArrayLen(result.pos) GT 1 ) {
			for(i=2; i LTE ArrayLen(result.pos); i++){
				if(not StructKeyExists(final, '$#i-1#')){
					final['$#i-1#'] = ArrayNew(1);
				}
				ArrayAppend(final['$#i-1#'], Mid(arguments.text, result.pos[i], result.len[i]));
			}
			pos = result.pos[2] + 1;
			result	= ReFindNoCase( arguments.regex, arguments.text, pos, true );
		} ;

		return final;
	}

	private any function _localCache( required string key, required any producer, struct args={} ) {
		variables._cache = variables._cache ?: StructNew( "weak" );

		var skipCache = IsBoolean( arguments.args.skipCache ?: "" ) && arguments.args.skipCache;
		if ( skipCache || !variables._cache.keyExists( arguments.key ) ) {
			variables._cache[ arguments.key ] = arguments.producer( argumentCollection=args );
		}

		return variables._cache[ arguments.key ] ?: NullValue();
	}

	public void function flushCaches() {
		variables._cache = StructNew( "weak" );
	}

}