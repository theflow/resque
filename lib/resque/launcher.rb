module Resque
  class Launcher
    # We don't do a lot of standard daemonization stuff:
    #   * umask is whatever was set by the parent process at startup
    #     and can be set in config.ru and config_file, so making it
    #     0000 and potentially exposing sensitive log data can be bad
    #     policy.
    #   * don't bother to chdir("/") here.
    def self.daemonize!
      $stdin.reopen("/dev/null")

      exit if fork
      Process.setsid
      exit if fork

      $stdin.sync = $stdout.sync = $stderr.sync = true
    end
  end
end
