# app.py
from flask import Flask
from controllers.usuarios_controlador import usuarios_bp
from config import Configuracion

def crear_app():
    app = Flask(__name__)
    app.config.from_object(Configuracion)

    # Registrar blueprints
    app.register_blueprint(usuarios_bp, url_prefix='/usuarios')

    return app

if __name__ == '__main__':
    aplicacion = crear_app()
    aplicacion.run(debug=True)