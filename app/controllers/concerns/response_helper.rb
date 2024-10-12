module ResponseHelper
  def render_error(status, errors, options = {})
    render status: status, json: { success: false, errors: errors }
  end
end
