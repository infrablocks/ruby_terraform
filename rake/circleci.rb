require 'rubygems'
require 'excon'
require 'yaml'
require 'json'

class CircleCI
  def initialize(config_path)
    config = YAML.load_file(config_path)

    @api_token = config["circle_ci_api_token"]
    @base_url = config["circle_ci_base_url"]
    @project_slug = config["circle_ci_project_slug"]
  end

  def find_env_vars
    response = assert_successful(Excon.get(env_vars_url, headers: headers))
    body = JSON.parse(response.body)
    env_vars = body["items"].map { |item| item["name"] }

    env_vars
  end

  def delete_env_var(name)
    assert_successful(Excon.delete(env_var_url(name), headers: headers))
  end

  def delete_env_vars
    env_vars = find_env_vars
    env_vars.each do |env_var|
      delete_env_var(env_var)
    end
  end

  def create_env_var(name, value)
    body = JSON.dump(name: name, value: value)
    assert_successful(
        Excon.post(env_vars_url, body: body, headers: headers))
  end

  def find_ssh_keys
    response = assert_successful(Excon.get(settings_url, headers: headers))
    body = JSON.parse(response.body)
    ssh_keys = body["ssh_keys"].map do |ssh_key|
      {
          fingerprint: ssh_key["fingerprint"],
          hostname: ssh_key["hostname"]
      }
    end

    ssh_keys
  end

  def delete_ssh_key(ssh_key_identifier)
    assert_successful(
        Excon.delete(ssh_keys_url,
            body: JSON.dump(ssh_key_identifier),
            headers: headers))
  end

  def delete_ssh_keys
    ssh_keys = find_ssh_keys
    ssh_keys.each do |ssh_key|
      delete_ssh_key(ssh_key)
    end
  end

  def create_ssh_key(ssh_key)
    body = JSON.dump({
        fingerprint: ssh_key.sha1_fingerprint,
        hostname: ssh_key.comment,
        private_key: ssh_key.private_key
    })
    assert_successful(
        Excon.post(ssh_keys_url, body: body, headers: headers))
  end

  private

  def headers
    {
        "Circle-Token": @api_token,
        "Content-Type": "application/json",
        "Accept": "application/json"
    }
  end

  def assert_successful(response)
    unless response.status >= 200 && response.status < 300
      host = response.data[:host]
      path = response.data[:path]
      status = response.status
      reason = response.data[:reason_phrase]
      raise "Unsuccessful request: #{host}#{path} #{status} #{reason}"
    end
    response
  end

  def env_vars_url
    "#{@base_url}/v2/project/#{@project_slug}/envvar"
  end

  def env_var_url(name)
    "#{@base_url}/v2/project/#{@project_slug}/envvar/#{name}"
  end

  def settings_url
    "#{@base_url}/v1.1/project/#{@project_slug}/settings"
  end

  def ssh_keys_url
    "#{@base_url}/v1.1/project/#{@project_slug}/ssh-key?" +
        "circle-token=#{@api_token}"
  end
end