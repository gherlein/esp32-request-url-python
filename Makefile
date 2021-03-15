NAME	:= esp32-request-url-python
ROLE	:= arn:aws:iam::497939524935:role/esp32-request-role
PY	:= main.py
HANDLER := $(basename $(PY)).lambda_handler
ZIP	:= function.zip
OUT	:= response.json
PAYLOAD := '{"key": "volume", "val": 100 }'
DEPS	:= boto3 uuid

all: clean build update run

build: 
	zip -r9 ${ZIP} main.py

clean:
	-rm *~
	-rm *zip
	-rm ${OUT}
	-rm -Rf venv

create: build
	aws lambda create-function --function-name ${NAME} --runtime python3.8 --zip-file fileb://${ZIP} --handler ${HANDLER} --role ${ROLE} 

update:
	aws lambda update-function-code --function-name ${NAME} --zip-file fileb://${ZIP}

run:
	aws lambda invoke --function-name ${NAME}  --payload ${PAYLOAD} ${OUT}
	cat ${OUT}
	echo



