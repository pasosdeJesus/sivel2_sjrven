# encoding: UTF-8

require 'application_system_test_case'

class UsuarioTest < ApplicationSystemTestCase

  test "no autentica con clave errada a usuario existente" do
    @usuario = Usuario.find_by(nusuario: 'sjrven')
    visit main_app.new_usuario_session_path 
    fill_in "Usuario", with: @usuario.nusuario
    fill_in "Clave", with: 'ERRADA'
    click_button "Iniciar Sesión"
    assert_not page.has_content?("Administrar")
  end

  test "autentica con usuario creado en prueba" do
    @usuario = Usuario.create(PRUEBA_USUARIO)
    visit main_app.new_usuario_session_path 
    fill_in "Usuario", with: @usuario.nusuario
    fill_in "Clave", with: @usuario.password
    click_button "Iniciar Sesión"
    assert page.has_content?("Administrar")
    @usuario.destroy
  end

  test "autentica con usuario existente en base inicial" do
    @usuario = Usuario.find_by(nusuario: 'sjrven')
    @usuario.password = 'sjrven123'
    visit main_app.new_usuario_session_path 
    fill_in "Usuario", with: @usuario.nusuario
    fill_in "Clave", with: @usuario.password
    click_button "Iniciar Sesión"
    assert page.has_content?("Administrar")
  end

end

