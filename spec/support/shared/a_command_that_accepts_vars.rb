# frozen_string_literal: true

shared_examples(
  'a command that accepts vars'
) do |command_klass, subcommand|
  it_behaves_like(
    'a valid command line',
    command_klass,
    reason: 'adds a var option for each supplied var',
    expected: "terraform #{subcommand} -var 'first=1' -var 'second=two'",
    binary: 'terraform',
    parameters: {
      vars: {
        first: 1,
        second: 'two'
      }
    }
  )

  it_behaves_like(
    'a valid command line',
    command_klass,
    reason: 'correctly serialises list/tuple vars',
    expected: "terraform #{subcommand} -var 'list=[1,\"two\",3]'",
    binary: 'terraform',
    parameters: {
      vars: {
        list: [1, 'two', 3]
      }
    }
  )

  it_behaves_like(
    'a valid command line',
    command_klass,
    reason: 'correctly serialises map/object vars',
    expected:
      "terraform #{subcommand} -var 'map={\"first\":1,\"second\":\"two\"}'",
    binary: 'terraform',
    parameters: {
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
    reason: 'correctly serialises vars with lists/tuples of maps/objects',
    expected:
      "terraform #{subcommand} -var " \
      "'list_of_maps=[{\"key\":\"val1\"},{\"key\":\"val2\"}]'",
    binary: 'terraform',
    parameters: {
      vars: {
        list_of_maps: [
          { key: 'val1' },
          { key: 'val2' }
        ]
      }
    }
  )
end
