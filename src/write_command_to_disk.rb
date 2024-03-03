require_relative "generate_command"

module Foobara
  module Generators
    module CommandGenerator
      class WriteCommandToDisk < Foobara::Generators::WriteGeneratedFilesToDisk
        class << self
          def generator_key
            "command"
          end
        end

        depends_on GenerateCommand

        inputs do
          command_config CommandConfig, :required
          # TODO: should be able to delete this and inherit it
          output_directory :string
        end

        def execute
          generate_file_contents
          delete_old_files_if_needed
          write_all_files_to_disk
          run_post_generation_tasks

          paths_to_source_code
        end

        def output_directory
          inputs[:output_directory] || default_output_directory
        end

        def default_output_directory
          "."
        end

        def generate_file_contents
          # TODO: just pass this in as the inputs instead of the command??
          self.paths_to_source_code = run_subcommand!(GenerateCommand, command_config.attributes)
        end

        def run_post_generation_tasks
          Dir.chdir output_directory do
            rubocop_autocorrect
          end
        end

        def rubocop_autocorrect
          # :nocov:
          Open3.popen3("bundle exec rubocop -A") do |_stdin, _stdout, stderr, wait_thr|
            exit_status = wait_thr.value
            unless exit_status.success?
              raise "could not rubocop -A. #{stderr.read}"
            end
          end
          # :nocov:
        end
      end
    end
  end
end
