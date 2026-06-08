BUILD_DIR=build
MKDIR = mkdir
CXX=c++

all: $(BUILD_DIR)/mad-cps2-encrypt

$(BUILD_DIR)/mad-cps2-encrypt: mad-cps2-encrypt.cpp $(BUILD_DIR)
	$(CC) mad-cps2-encrypt.cpp -o $(BUILD_DIR)/mad-cps2-encrypt

$(BUILD_DIR):
	$(MKDIR) -p $(BUILD_DIR)

clean:
	rm -rf build
