SOURCE := README.md
TARGET := CV.pdf

.PHONY: all clean

all: $(TARGET)

$(TARGET): $(SOURCE) build.sh
	./build.sh $(SOURCE) $(TARGET)

clean:
	rm -f $(TARGET)
