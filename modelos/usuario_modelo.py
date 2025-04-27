# modelos/usuario_modelo.py
from config import Configuracion

class UsuarioModelo:

    @staticmethod
    def obtener_todos():
        conexion = Configuracion.obtener_conexion()
        cursor = conexion.cursor()
        cursor.execute("EXEC dbo.usp_Usuarios_Listar")  # SP que lista usuarios
        filas = cursor.fetchall()
        cursor.close()
        conexion.close()
        return filas

    @staticmethod
    def insertar(nombre, apellido, correo, creado_por):
        conexion = Configuracion.obtener_conexion()
        cursor = conexion.cursor()
        exito = False
        mensaje = ''
        try:
            parametros = (nombre, apellido, correo, creado_por)
            # Ajustar llamada según SP definido: parámetros y OUTPUT
            cursor.execute("EXEC dbo.usp_Usuarios_Insertar ?, ?, ?, ?, ?, ?, ? OUTPUT, ? OUTPUT, ? OUTPUT",
                           parametros + (None, None, None))
            # Recuperar parámetros OUTPUT
            nuevo_id = cursor.getoutputs()[0]
            exito = cursor.getoutputs()[1]
            mensaje = cursor.getoutputs()[2]
            conexion.commit()
        except Exception as e:
            conexion.rollback()
            mensaje = str(e)
        finally:
            cursor.close()
            conexion.close()
        return exito, mensaje