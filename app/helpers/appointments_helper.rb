# Helper methods defined here can be accessed in any controller or view in the application
require 'active_support/all'

Rene::App.helpers do
  # def simple_helper_method
  # ...
  # end

  def render_date(date)
    date.to_datetime
  end

  def render_hour(hour)
    hour[0..1].to_i
  end

  def render_minutes(hour)
    hour[3..4].to_i
  end

  def valid_hour?(hour)
    (hour=~/^([0-9]|0[0-9]|1[0-9]|2[0-3]):[0-5][0-9]$/) == 0
  end

  def valid_date?(str, format="%Y-%m-%d")
    date = Date.strptime(str,format) rescue false
    date.is_a?(Date)
  end

  def valid_medic_name?(medic_name)
    name = medic_name.delete(" ")
    /[[:alpha:]]+/.match(name).to_s == name
  end

  def valid_patient_name?(patient_name)
    !patient_name.match(" ")  
  end

  def one_is_empty?(hour, date, medic_name, duration, patient_name)
    hour == "" || date == "" || medic_name == "" || duration == "" || patient_name == ""
  end

  def validation(hour, date, medic_name, duration, patient_name)
    valid_hour?(hour) && valid_date?(date) && valid_medic_name?(medic_name) && 
    valid_patient_name?(patient_name) && ! one_is_empty?(hour, date, medic_name, duration, patient_name)
  end

  def validation_error(hour, date, medic_name, duration, patient_name)
    case
      when hour == "" then "Error: El campo 'Horario' es requerido."
      when date == "" then "Error: El campo 'Fecha' es requerido."
      when medic_name == "" then "Error: El campo 'Nombre del medico' es requerido."
      when duration == "" then "Error: El campo 'Tiempo de consulta' es requerido."
      when patient_name == "" then "Error: El nombre de usuario del paciente es requerido."
      when ! (valid_hour?(hour)) then "Error: El formato de hora debe ser HH:MM."
      when ! (valid_date?(date)) then "Error: El formato de fecha debe ser aaaa-mm-dd."
      when ! (valid_medic_name?(medic_name)) then "Error: El nombre debe contener solo letras."
      when ! (valid_patient_name?(patient_name)) then "Error: El nombre de usuario del paciente no debe contener espacios."
    end    
  end


  def render_list(rol)
      if rol == "Consultorio"
         @appointments = current_account.medic_list_upcoming_appointments
      else
         @appointments = current_account.patient_list_upcoming_appointments
      end
      @rol = rol
      render 'appointments/list'
  end

end
