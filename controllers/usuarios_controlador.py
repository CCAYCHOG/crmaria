# controllers/usuarios_controlador.py
from flask import Blueprint, render_template, request, redirect, url_for, flash
from modelos.usuario_modelo import UsuarioModelo

usuarios_bp = Blueprint('usuarios', __name__, template_folder='templates/usuarios')

@usuarios_bp.route('/')
def lista_usuarios():
    usuarios = UsuarioModelo.obtener_todos()
    return render_template('usuarios/lista.html', usuarios=usuarios)

@usuarios_bp.route('/crear', methods=['POST'])
def crear_usuario():
    nombre = request.form.get('nombre')
    apellido = request.form.get('apellido')
    correo = request.form.get('correo')
    creado_por = 1  # ejemplo: ID del usuario logueado

    exito, mensaje = UsuarioModelo.insertar(nombre, apellido, correo, creado_por)
    flash(mensaje, 'success' if exito else 'danger')
    return redirect(url_for('usuarios.lista_usuarios'))