# config.py
import pyodbc

class Configuracion:
    SECRET_KEY = 'cambiar_por_una_clave_segura'
    DB_DRIVER = 'ODBC Driver 17 for SQL Server'
    DB_SERVER = 'localhost'
    DB_DATABASE = 'crmaria'
    DB_USER = 'tu_usuario'
    DB_PASSWORD = 'tu_contraseña'

    @staticmethod
    def obtener_conexion():
        cadena = (
            f"DRIVER={{{Configuracion.DB_DRIVER}}};"
            f"SERVER={Configuracion.DB_SERVER};"
            f"DATABASE={Configuracion.DB_DATABASE};"
            f"UID={Configuracion.DB_USER};"
            f"PWD={Configuracion.DB_PASSWORD};"
        )
        return pyodbc.connect(cadena)