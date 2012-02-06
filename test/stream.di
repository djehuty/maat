module io.stream;

/*
This class represents a data stream of arbitrary bytes.
*/
final class Stream {
//public:

	/*
	This function will read a number of bytes from the stream at the current
	  position. The content will be copied into the given buffer.
	buffer: A buffer that will receive the read data.
	*/
	void read(ubyte[] buffer);
	void read(Stream buffer, size_t length);

	/*
	This function will read a number of bytes from the stream at the current
	  position. These bytes will be returned by a buffer supplied by the
	  stream. It will be a shallow copy whenever possible.
	length: The number of bytes to read.
	*/
	ubyte[] read(size_t length);

	/*
	This function will move the position relative to its current value.
	position: An offset to move the current position of the stream.
	*/
	void seek(long position) {
		int i = 3, b = 2;
		int a = 5;

		if (a == 5) {
			if (b == 2) {
				int p = 42;
			}
			int x = 4;
		}
		else {
			2 + 2;
		}
	}
}
