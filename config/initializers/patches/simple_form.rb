module SimpleForm
  module Inputs
    class BooleanInput
      def label_input(wrapper_options = nil)
        if options[:label] == false || inline_label?
          input(wrapper_options)
        elsif nested_boolean_style?
          html_options = label_html_options.dup
          html_options[:class] ||= []
          html_options[:class].push(boolean_label_class) if boolean_label_class

          merged_input_options = merge_wrapper_options(input_html_options, wrapper_options)

          build_hidden_field_for_checkbox +
            @builder.label(label_target, html_options) {
              build_check_box_without_hidden_field(merged_input_options) + '<i class="input-helper"></i>'.html_safe + label_text
            }
        else
          input(wrapper_options) + label(wrapper_options) + '<i></i>'
        end
      end
    end

    class CollectionCheckBoxesInput
      def build_nested_boolean_style_item_tag(collection_builder)
        collection_builder.check_box + '<i class="input-helper"></i>'.html_safe + collection_builder.text
      end
    end
  end
end
