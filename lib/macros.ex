defmodule Macros do
  defmacro defcase({fun, _ctx, args}, block) do
    args = [
      input = Macro.var(:input, nil)
      | args
    ]
    quote do
      def unquote(fun)(unquote_splicing(args)) do
        case unquote(input) do
          unquote(Keyword.get(block, :do))
        end
      end
    end
  end
end
