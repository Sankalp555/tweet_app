module Response
  def json_response(status, status_code, message, object)
    render json: { status: status, status_code: status_code, message: message, data: object }
  end
end