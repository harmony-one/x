FROM python:3.10-bookworm
WORKDIR /service
COPY . ./

RUN python -m pip uninstall pip-tools
RUN pip install pip-tools

RUN pip install -r requirements.txt

EXPOSE 8080
ENTRYPOINT ["python3", "app.py"]