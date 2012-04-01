module Space
  class Repos
    class Scope < Array
      attr_reader :repos

      def initialize(repos, elements)
        @repos = repos
        super(elements)
      end

      def self_and_dependencies
        Scope.new(repos, (self + map(&:dependencies)).flatten.uniq)
      end
    end

    attr_accessor :project, :paths, :scope

    def initialize(project, paths)
      @project = project
      @paths = paths
    end

    def all
      @all ||= Scope.new(self, paths.map { |path| Repo.new(project, self, path) })
    end

    def scope
      @scope || all
    end

    def scoped?
      !!@scope
    end

    def names
      all.map(&:name)
    end

    def find_by_name(name)
      all.detect { |repo| repo.name == name }
    end

    def select_by_names(names)
      Scope.new(self, all.select { |repo| names.include?(repo.name) })
    end

    def add_observer(observer)
      all.each { |repo| repo.add_observer(observer) }
    end
  end
end
