from flask import Flask

app = Flask(__name__)

@app.route('/')
def home():
    return '¡Hola, Flask en Windows 11!'

if __name__ == '__main__':
    # Para desarrollo: recarga automática y debug activado
    app.run(host='127.0.0.1', port=5000, debug=True)