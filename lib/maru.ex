defmodule Maru do
  @moduledoc """
  This is documentation for maru.

  Maru is a REST-like API micro-framework depends on [plug](http://hexdocs.pm/plug) for [elixir](http://elixir-lang.org) inspired by [grape](https://github.com/ruby-grape/grape).
  """

  use Application

  @doc """
  Maru version.
  """
  @version Mix.Project.config[:version]
  def version do
    @version
  end

  @doc false
  def start(_type, _args) do
    Maru.Supervisor.start_link
  end

  @doc false
  def servers do
    servers =
      Enum.filter(Application.get_all_env(:maru), fn {k, _} ->
        match?("Elixir." <> _, to_string(k))
      end)
    # If Confex is available, replace all system variables
    case Code.ensure_loaded?(Confex) do
      true ->
        Enum.map(servers, fn {k, v} ->
          {k, Confex.process_env(v)}
        end)
      false ->
        servers
    end
  end

end
