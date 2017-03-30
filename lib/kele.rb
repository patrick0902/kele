Bundler.require(:default, :development)
require_relative './roadmap'
require_relative './kele'
include HTTParty, Json, Roadmap

class Kele
  def initialize(email, password)
    @email = email
    @password = password

    response = self.class.post('https://www.bloc.io/api/v1/sessions', body: { "email": @email, "password": @password})
    @auth_token = response[ "auth_token" ]

    if @auth_token.nil? || response.nil?
      raise Error, "Unable to access user. Please try again with valid user information."
    end
  end

  def get_me
  response = self.class.get('https://www.bloc.io/api/v1/users/me', headers: { "authorization": @auth_token })
  JSON.parse(response.body)
  end

  def get_mentor_availability(mentor_id)
  response = self.class.get("https://www.bloc.io/api/v1/mentors/#{mentor_id}/student_availability", headers: { "authorization": @auth_token })
  JSON.parse(response.body)
  end
  
  def get_messages(page = nil) # optional method parameter
    if page != nil # return specified page
      response = self.class.get("https://www.bloc.io/api/v1/message_threads", headers: { "authorization": @auth_token }, body: { "page": page })
    else # return first page
      response = self.class.get("https://www.bloc.io/api/v1/message_threads", headers: { "authorization": @auth_token })
    end
    JSON.parse(response.body)
  end

  def create_message(sender, recipient_id, subject, stripped_text)
    response = self.class.post("https://www.bloc.io/api/v1/messages", headers: { "authorization": @auth_token },
      body: {
        "sender": sender,
        "recipient_id": recipient_id,
        "subject": subject,
        "stripped-text": stripped_text
      })
  end
end
