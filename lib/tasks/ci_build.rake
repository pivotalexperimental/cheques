desc "Run 'cheques' ci build"
task :ci_build do
  Rake::Task["spec"].invoke
end
