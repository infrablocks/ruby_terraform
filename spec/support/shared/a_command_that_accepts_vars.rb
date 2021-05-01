# frozen_string_literal: true

shared_examples(
  'a command that accepts vars'
) do |command_klass, subcommand, directory|
  it_behaves_like(
    'a valid command line',
    command_klass,
    binary: 'terraform',
    reason: 'adds a var option for each supplied var',
    expected:
      "terraform #{subcommand} -var 'first=1' -var 'second=two' #{directory}",
    options: {
      directory: directory,
      vars: {
        first: 1,
        second: 'two'
      }
    }
  )

  it_behaves_like(
    'a valid command line',
    command_klass,
    binary: 'terraform',
    reason: 'correctly serialises list/tuple vars',
    expected:
      "terraform #{subcommand} -var 'list=[1,\"two\",3]' #{directory}",
    options: {
      directory: directory,
      vars: {
        list: [1, 'two', 3]
      }
    }
  )

  it_behaves_like(
    'a valid command line',
    command_klass,
    binary: 'terraform',
    reason: 'correctly serialises map/object vars',
    expected:
      "terraform #{subcommand} -var 'map={\"first\":1,\"second\":\"two\"}' " +
        directory,
    options: {
      directory: directory,
      vars: {
        map: {
          first: 1,
          second: 'two'
        }
      }
    }
  )

  it_behaves_like(
    'a valid command line',
    command_klass,
    binary: 'terraform',
    reason: 'correctly serialises vars with lists/tuples of maps/objects',
    expected:
      "terraform #{subcommand} -var " \
          "'list_of_maps=[{\"key\":\"val1\"},{\"key\":\"val2\"}]' #{directory}",
    options: {
      directory: directory,
      vars: {
        list_of_maps: [
          { key: 'val1' },
          { key: 'val2' }
        ]
      }
    }
  )
end
