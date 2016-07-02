require 'spec_helper'

describe Ricer4::Plugins::Imgur do
  
  # LOAD
  bot = Ricer4::Bot.new("ricer4.spec.conf.yml")
  bot.db_connect
  ActiveRecord::Magic::Update.install
  ActiveRecord::Magic::Update.run
  bot.load_plugins
  ActiveRecord::Magic::Update.run

  it("can request random") do
    expect(bot.exec_line_as_for("Ugah", "Imgur/Imgur")).to start_with("msg_image:{\"image\":\"")
  end
  
  it("can request category") do
    expect(bot.exec_line_as_for("Ugah", "Imgur/Imgur", "hot")).to start_with("msg_image:{\"image\":\"")
  end
  
  it("fails on unknown category") do
    expect(bot.exec_line_as_for("Ugah", "Imgur/Imgur", "bot")).to start_with("err_usage:{\"error\":\"err_unknown_enum\",")
  end

end
