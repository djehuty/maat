module io.stream;

/*
This class represents a data stream of arbitrary bytes.
*/
final class Stream {
//public:

	this();

	/*
	This constructor will create a stream attached to predefined functions.
	*/
	this(void delegate(ubyte[] buffer) readInto,
	     ubyte[] delegate(size_t length) read,
	     void delegate(ubyte[] data) write,
	     void delegate(ubyte[] data) append,
	     void delegate(long amount) seek,
	     size_t delegate() length,
	     size_t delegate() available,
	     size_t delegate() position);
}
