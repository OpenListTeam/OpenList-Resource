// TypeScript bindings for emscripten-generated code.  Automatically generated at compile time.
declare namespace RuntimeExports {
    let HEAPF32: any;
    let HEAPF64: any;
    let HEAP_DATA_VIEW: any;
    let HEAP8: any;
    let HEAPU8: any;
    let HEAP16: any;
    let HEAPU16: any;
    let HEAP32: any;
    let HEAPU32: any;
    let HEAP64: any;
    let HEAPU64: any;
}
interface WasmModule {
  _memcpy(_0: number, _1: number, _2: number): number;
  _heif_color_conversion_options_set_defaults(_0: number): void;
  _malloc(_0: number): number;
  _heif_nclx_color_profile_set_color_primaries(_0: number, _1: number, _2: number): void;
  _free(_0: number): void;
  _heif_nclx_color_profile_set_transfer_characteristics(_0: number, _1: number, _2: number): void;
  _heif_nclx_color_profile_set_matrix_coefficients(_0: number, _1: number, _2: number): void;
  _heif_init(_0: number, _1: number): void;
  _heif_deinit(): void;
  _heif_load_plugin(_0: number, _1: number, _2: number): void;
  _heif_unload_plugin(_0: number, _1: number): void;
  _heif_load_plugins(_0: number, _1: number, _2: number, _3: number, _4: number): void;
  _heif_get_plugin_directories(): number;
  _heif_free_plugin_directories(_0: number): void;
  _heif_get_version(): number;
  _heif_get_version_number(): number;
  _heif_get_version_number_major(): number;
  _heif_get_version_number_minor(): number;
  _heif_get_version_number_maintenance(): number;
  _heif_check_filetype(_0: number, _1: number): number;
  _heif_read_main_brand(_0: number, _1: number): number;
  _heif_has_compatible_filetype(_0: number, _1: number, _2: number): void;
  _heif_list_compatible_brands(_0: number, _1: number, _2: number, _3: number, _4: number): void;
  _heif_free_list_of_compatible_brands(_0: number): void;
  _heif_check_jpeg_filetype(_0: number, _1: number): number;
  _heif_main_brand(_0: number, _1: number): number;
  _heif_fourcc_to_brand(_0: number): number;
  _heif_read_minor_version_brand(_0: number, _1: number): number;
  _heif_brand_to_fourcc(_0: number, _1: number): void;
  _heif_has_compatible_brand(_0: number, _1: number, _2: number): number;
  _heif_get_global_security_limits(): number;
  _heif_get_file_mime_type(_0: number, _1: number): number;
  _heif_get_disabled_security_limits(): number;
  _heif_context_get_security_limits(_0: number): number;
  _heif_context_set_security_limits(_0: number, _1: number, _2: number): void;
  _heif_context_alloc(): number;
  _heif_context_free(_0: number): void;
  _heif_context_read_from_file(_0: number, _1: number, _2: number, _3: number): void;
  _heif_context_read_from_memory(_0: number, _1: number, _2: number, _3: number, _4: number): void;
  _heif_context_read_from_memory_without_copy(_0: number, _1: number, _2: number, _3: number, _4: number): void;
  _heif_context_read_from_reader(_0: number, _1: number, _2: number, _3: number, _4: number): void;
  _heif_context_debug_dump_boxes_to_file(_0: number, _1: number): void;
  _heif_context_get_primary_image_handle(_0: number, _1: number, _2: number): void;
  _heif_context_get_primary_image_ID(_0: number, _1: number, _2: number): void;
  _heif_context_is_top_level_image_ID(_0: number, _1: number): number;
  _heif_context_get_number_of_top_level_images(_0: number): number;
  _heif_context_get_list_of_top_level_image_IDs(_0: number, _1: number, _2: number): number;
  _heif_context_get_image_handle(_0: number, _1: number, _2: number, _3: number): void;
  _heif_image_handle_is_primary_image(_0: number): number;
  _heif_image_handle_get_item_id(_0: number): number;
  _heif_image_handle_get_number_of_thumbnails(_0: number): number;
  _heif_image_handle_get_list_of_thumbnail_IDs(_0: number, _1: number, _2: number): number;
  _heif_image_handle_get_thumbnail(_0: number, _1: number, _2: number, _3: number): void;
  _heif_image_handle_get_number_of_auxiliary_images(_0: number, _1: number): number;
  _heif_image_handle_get_list_of_auxiliary_image_IDs(_0: number, _1: number, _2: number, _3: number): number;
  _heif_image_handle_get_auxiliary_type(_0: number, _1: number, _2: number): void;
  _heif_image_handle_release_auxiliary_type(_0: number, _1: number): void;
  _heif_image_handle_free_auxiliary_types(_0: number, _1: number): void;
  _heif_image_handle_get_auxiliary_image_handle(_0: number, _1: number, _2: number, _3: number): void;
  _heif_image_handle_get_width(_0: number): number;
  _heif_image_handle_get_height(_0: number): number;
  _heif_image_handle_get_ispe_width(_0: number): number;
  _heif_image_handle_get_ispe_height(_0: number): number;
  _heif_image_handle_get_context(_0: number): number;
  _heif_image_handle_get_image_tiling(_0: number, _1: number, _2: number, _3: number): void;
  _heif_image_handle_get_grid_image_tile_id(_0: number, _1: number, _2: number, _3: number, _4: number, _5: number): void;
  _heif_context_get_entity_groups(_0: number, _1: number, _2: number, _3: number): number;
  _heif_entity_groups_release(_0: number, _1: number): void;
  _heif_image_handle_get_preferred_decoding_colorspace(_0: number, _1: number, _2: number, _3: number): void;
  _heif_image_handle_has_alpha_channel(_0: number): number;
  _heif_image_handle_is_premultiplied_alpha(_0: number): number;
  _heif_image_handle_get_luma_bits_per_pixel(_0: number): number;
  _heif_image_handle_get_chroma_bits_per_pixel(_0: number): number;
  _heif_image_handle_has_depth_image(_0: number): number;
  _heif_depth_representation_info_free(_0: number): void;
  _heif_image_handle_get_depth_image_representation_info(_0: number, _1: number, _2: number): number;
  _heif_image_handle_get_number_of_depth_images(_0: number): number;
  _heif_image_handle_get_list_of_depth_image_IDs(_0: number, _1: number, _2: number): number;
  _heif_image_handle_get_depth_image_handle(_0: number, _1: number, _2: number, _3: number): void;
  _heif_decoding_options_alloc(): number;
  _heif_decoding_options_free(_0: number): void;
  _heif_decode_image(_0: number, _1: number, _2: number, _3: number, _4: number, _5: number): void;
  _heif_image_handle_decode_image_tile(_0: number, _1: number, _2: number, _3: number, _4: number, _5: number, _6: number, _7: number): void;
  _heif_image_create(_0: number, _1: number, _2: number, _3: number, _4: number, _5: number): void;
  _heif_image_get_decoding_warnings(_0: number, _1: number, _2: number, _3: number): number;
  _heif_image_add_decoding_warning(_0: number, _1: number): void;
  _heif_image_has_content_light_level(_0: number): number;
  _heif_image_get_content_light_level(_0: number, _1: number): void;
  _heif_image_handle_get_content_light_level(_0: number, _1: number): number;
  _heif_image_set_content_light_level(_0: number, _1: number): void;
  _heif_image_has_mastering_display_colour_volume(_0: number): number;
  _heif_image_get_mastering_display_colour_volume(_0: number, _1: number): void;
  _heif_image_handle_get_mastering_display_colour_volume(_0: number, _1: number): number;
  _heif_image_set_mastering_display_colour_volume(_0: number, _1: number): void;
  _heif_mastering_display_colour_volume_decode(_0: number, _1: number, _2: number): void;
  _heif_image_get_pixel_aspect_ratio(_0: number, _1: number, _2: number): void;
  _heif_image_handle_get_pixel_aspect_ratio(_0: number, _1: number, _2: number): number;
  _heif_image_set_pixel_aspect_ratio(_0: number, _1: number, _2: number): void;
  _heif_image_release(_0: number): void;
  _heif_image_handle_release(_0: number): void;
  _heif_image_get_colorspace(_0: number): number;
  _heif_image_get_chroma_format(_0: number): number;
  _heif_image_get_width(_0: number, _1: number): number;
  _heif_image_get_height(_0: number, _1: number): number;
  _heif_image_get_primary_width(_0: number): number;
  _heif_image_get_primary_height(_0: number): number;
  _heif_image_crop(_0: number, _1: number, _2: number, _3: number, _4: number, _5: number): void;
  _heif_image_get_bits_per_pixel(_0: number, _1: number): number;
  _heif_image_get_bits_per_pixel_range(_0: number, _1: number): number;
  _heif_image_has_channel(_0: number, _1: number): number;
  _heif_image_add_plane(_0: number, _1: number, _2: number, _3: number, _4: number, _5: number): void;
  _heif_image_get_plane_readonly(_0: number, _1: number, _2: number): number;
  _heif_image_get_plane(_0: number, _1: number, _2: number): number;
  _heif_image_set_premultiplied_alpha(_0: number, _1: number): void;
  _heif_image_is_premultiplied_alpha(_0: number): number;
  _heif_image_extend_padding_to_size(_0: number, _1: number, _2: number, _3: number): void;
  _heif_image_scale_image(_0: number, _1: number, _2: number, _3: number, _4: number, _5: number): void;
  _heif_image_extend_to_size_fill_with_zero(_0: number, _1: number, _2: number, _3: number): void;
  _heif_image_set_raw_color_profile(_0: number, _1: number, _2: number, _3: number, _4: number): void;
  _heif_image_set_nclx_color_profile(_0: number, _1: number, _2: number): void;
  _heif_image_handle_get_number_of_metadata_blocks(_0: number, _1: number): number;
  _heif_image_handle_get_list_of_metadata_block_IDs(_0: number, _1: number, _2: number, _3: number): number;
  _heif_image_handle_get_metadata_type(_0: number, _1: number): number;
  _heif_image_handle_get_metadata_content_type(_0: number, _1: number): number;
  _heif_image_handle_get_metadata_item_uri_type(_0: number, _1: number): number;
  _heif_image_handle_get_metadata_size(_0: number, _1: number): number;
  _heif_image_handle_get_metadata(_0: number, _1: number, _2: number, _3: number): void;
  _heif_image_handle_get_color_profile_type(_0: number): number;
  _heif_image_handle_get_raw_color_profile_size(_0: number): number;
  _heif_image_handle_get_nclx_color_profile(_0: number, _1: number, _2: number): void;
  _heif_image_handle_get_raw_color_profile(_0: number, _1: number, _2: number): void;
  _heif_image_get_color_profile_type(_0: number): number;
  _heif_image_get_raw_color_profile_size(_0: number): number;
  _heif_image_get_raw_color_profile(_0: number, _1: number, _2: number): void;
  _heif_image_get_nclx_color_profile(_0: number, _1: number, _2: number): void;
  _heif_nclx_color_profile_alloc(): number;
  _heif_nclx_color_profile_free(_0: number): void;
  _heif_image_handle_has_camera_intrinsic_matrix(_0: number): number;
  _heif_image_handle_get_camera_intrinsic_matrix(_0: number, _1: number, _2: number): void;
  _heif_image_handle_has_camera_extrinsic_matrix(_0: number): number;
  _heif_image_handle_get_camera_extrinsic_matrix(_0: number, _1: number, _2: number): void;
  _heif_camera_extrinsic_matrix_release(_0: number): void;
  _heif_camera_extrinsic_matrix_get_rotation_matrix(_0: number, _1: number, _2: number): void;
  _heif_register_decoder(_0: number, _1: number, _2: number): void;
  _heif_register_decoder_plugin(_0: number, _1: number): void;
  _heif_register_encoder_plugin(_0: number, _1: number): void;
  _heif_context_write_to_file(_0: number, _1: number, _2: number): void;
  _heif_context_write(_0: number, _1: number, _2: number, _3: number): void;
  _heif_context_add_compatible_brand(_0: number, _1: number): void;
  _heif_context_get_encoder_descriptors(_0: number, _1: number, _2: number, _3: number, _4: number): number;
  _heif_get_encoder_descriptors(_0: number, _1: number, _2: number, _3: number): number;
  _heif_encoder_descriptor_get_name(_0: number): number;
  _heif_encoder_descriptor_get_id_name(_0: number): number;
  _heif_get_decoder_descriptors(_0: number, _1: number, _2: number): number;
  _heif_decoder_descriptor_get_name(_0: number): number;
  _heif_decoder_descriptor_get_id_name(_0: number): number;
  _heif_encoder_descriptor_get_compression_format(_0: number): number;
  _heif_encoder_descriptor_supports_lossy_compression(_0: number): number;
  _heif_encoder_descriptor_supports_lossless_compression(_0: number): number;
  _heif_encoder_descriptor_supportes_lossy_compression(_0: number): number;
  _heif_encoder_descriptor_supportes_lossless_compression(_0: number): number;
  _heif_encoder_get_name(_0: number): number;
  _heif_context_get_encoder(_0: number, _1: number, _2: number, _3: number): void;
  _heif_have_decoder_for_format(_0: number): number;
  _heif_have_encoder_for_format(_0: number): number;
  _heif_context_get_encoder_for_format(_0: number, _1: number, _2: number, _3: number): void;
  _heif_encoder_release(_0: number): void;
  _heif_encoder_set_lossy_quality(_0: number, _1: number, _2: number): void;
  _heif_encoder_set_lossless(_0: number, _1: number, _2: number): void;
  _heif_encoder_set_logging_level(_0: number, _1: number, _2: number): void;
  _heif_encoder_list_parameters(_0: number): number;
  _heif_encoder_parameter_get_name(_0: number): number;
  _heif_encoder_parameter_get_type(_0: number): number;
  _heif_encoder_set_parameter_integer(_0: number, _1: number, _2: number, _3: number): void;
  _heif_encoder_parameter_get_valid_integer_values(_0: number, _1: number, _2: number, _3: number, _4: number, _5: number, _6: number, _7: number): void;
  _heif_encoder_get_parameter_integer(_0: number, _1: number, _2: number, _3: number): void;
  _heif_encoder_parameter_get_valid_integer_range(_0: number, _1: number, _2: number, _3: number, _4: number): void;
  _heif_encoder_parameter_get_valid_string_values(_0: number, _1: number, _2: number): void;
  _heif_encoder_parameter_integer_valid_range(_0: number, _1: number, _2: number, _3: number, _4: number, _5: number): void;
  _heif_encoder_set_parameter_boolean(_0: number, _1: number, _2: number, _3: number): void;
  _heif_encoder_get_parameter_boolean(_0: number, _1: number, _2: number, _3: number): void;
  _heif_encoder_set_parameter_string(_0: number, _1: number, _2: number, _3: number): void;
  _heif_encoder_get_parameter_string(_0: number, _1: number, _2: number, _3: number, _4: number): void;
  _heif_encoder_parameter_string_valid_values(_0: number, _1: number, _2: number, _3: number): void;
  _heif_encoder_parameter_integer_valid_values(_0: number, _1: number, _2: number, _3: number, _4: number, _5: number, _6: number, _7: number, _8: number): void;
  _heif_encoder_set_parameter(_0: number, _1: number, _2: number, _3: number): void;
  _heif_encoder_get_parameter(_0: number, _1: number, _2: number, _3: number, _4: number): void;
  _heif_encoder_has_default(_0: number, _1: number): number;
  _heif_encoding_options_alloc(): number;
  _heif_encoding_options_free(_0: number): void;
  _heif_context_encode_image(_0: number, _1: number, _2: number, _3: number, _4: number, _5: number): void;
  _heif_context_encode_grid(_0: number, _1: number, _2: number, _3: number, _4: number, _5: number, _6: number, _7: number): void;
  _heif_context_add_grid_image(_0: number, _1: number, _2: number, _3: number, _4: number, _5: number, _6: number, _7: number): void;
  _heif_context_add_overlay_image(_0: number, _1: number, _2: number, _3: number, _4: number, _5: number, _6: number, _7: number, _8: number): void;
  _heif_context_add_image_tile(_0: number, _1: number, _2: number, _3: number, _4: number, _5: number, _6: number): void;
  _heif_context_assign_thumbnail(_0: number, _1: number, _2: number, _3: number): void;
  _heif_context_encode_thumbnail(_0: number, _1: number, _2: number, _3: number, _4: number, _5: number, _6: number, _7: number): void;
  _heif_context_set_primary_image(_0: number, _1: number, _2: number): void;
  _heif_context_add_exif_metadata(_0: number, _1: number, _2: number, _3: number, _4: number): void;
  _heif_context_add_XMP_metadata(_0: number, _1: number, _2: number, _3: number, _4: number): void;
  _heif_context_add_XMP_metadata2(_0: number, _1: number, _2: number, _3: number, _4: number, _5: number): void;
  _heif_context_add_generic_metadata(_0: number, _1: number, _2: number, _3: number, _4: number, _5: number, _6: number): void;
  _heif_context_add_generic_uri_metadata(_0: number, _1: number, _2: number, _3: number, _4: number, _5: number, _6: number): void;
  _heif_context_set_maximum_image_size_limit(_0: number, _1: number): void;
  _heif_context_set_max_decoding_threads(_0: number, _1: number): void;
  _heif_image_handle_get_number_of_region_items(_0: number): number;
  _heif_image_handle_get_list_of_region_item_ids(_0: number, _1: number, _2: number): number;
  _heif_context_get_region_item(_0: number, _1: number, _2: number, _3: number): void;
  _heif_region_item_get_id(_0: number): number;
  _heif_region_item_release(_0: number): void;
  _heif_region_item_get_reference_size(_0: number, _1: number, _2: number): void;
  _heif_region_item_get_number_of_regions(_0: number): number;
  _heif_region_item_get_list_of_regions(_0: number, _1: number, _2: number): number;
  _heif_image_handle_add_region_item(_0: number, _1: number, _2: number, _3: number, _4: number): void;
  _heif_region_item_add_region_point(_0: number, _1: number, _2: number, _3: number, _4: number): void;
  _heif_region_item_add_region_rectangle(_0: number, _1: number, _2: number, _3: number, _4: number, _5: number, _6: number): void;
  _heif_region_item_add_region_ellipse(_0: number, _1: number, _2: number, _3: number, _4: number, _5: number, _6: number): void;
  _heif_region_item_add_region_polygon(_0: number, _1: number, _2: number, _3: number, _4: number): void;
  _heif_region_item_add_region_polyline(_0: number, _1: number, _2: number, _3: number, _4: number): void;
  _heif_region_item_add_region_referenced_mask(_0: number, _1: number, _2: number, _3: number, _4: number, _5: number, _6: number, _7: number): void;
  _heif_region_item_add_region_inline_mask_data(_0: number, _1: number, _2: number, _3: number, _4: number, _5: number, _6: number, _7: number, _8: number): void;
  _heif_region_item_add_region_inline_mask(_0: number, _1: number, _2: number, _3: number, _4: number, _5: number, _6: number, _7: number): void;
  _heif_region_release(_0: number): void;
  _heif_region_release_many(_0: number, _1: number): void;
  _heif_region_get_type(_0: number): number;
  _heif_region_get_point(_0: number, _1: number, _2: number, _3: number): void;
  _heif_region_get_point_transformed(_0: number, _1: number, _2: number, _3: number, _4: number): void;
  _heif_region_get_rectangle(_0: number, _1: number, _2: number, _3: number, _4: number, _5: number): void;
  _heif_region_get_rectangle_transformed(_0: number, _1: number, _2: number, _3: number, _4: number, _5: number, _6: number): void;
  _heif_region_get_ellipse(_0: number, _1: number, _2: number, _3: number, _4: number, _5: number): void;
  _heif_region_get_ellipse_transformed(_0: number, _1: number, _2: number, _3: number, _4: number, _5: number, _6: number): void;
  _heif_region_get_polygon_num_points(_0: number): number;
  _heif_region_get_polyline_num_points(_0: number): number;
  _heif_region_get_polygon_points(_0: number, _1: number, _2: number): void;
  _heif_region_get_polyline_points(_0: number, _1: number, _2: number): void;
  _heif_region_get_polygon_points_transformed(_0: number, _1: number, _2: number, _3: number): void;
  _heif_region_get_polyline_points_transformed(_0: number, _1: number, _2: number, _3: number): void;
  _heif_region_get_referenced_mask_ID(_0: number, _1: number, _2: number, _3: number, _4: number, _5: number, _6: number): void;
  _heif_region_get_inline_mask_data_len(_0: number): number;
  _heif_region_get_inline_mask_data(_0: number, _1: number, _2: number, _3: number, _4: number, _5: number, _6: number): void;
  _heif_region_get_mask_image(_0: number, _1: number, _2: number, _3: number, _4: number, _5: number, _6: number): void;
  _heif_item_get_properties_of_type(_0: number, _1: number, _2: number, _3: number, _4: number): number;
  _heif_item_get_transformation_properties(_0: number, _1: number, _2: number, _3: number): number;
  _heif_item_get_property_type(_0: number, _1: number, _2: number): number;
  _heif_item_get_property_user_description(_0: number, _1: number, _2: number, _3: number, _4: number): void;
  _heif_item_add_property_user_description(_0: number, _1: number, _2: number, _3: number, _4: number): void;
  _heif_item_get_property_transform_mirror(_0: number, _1: number, _2: number): number;
  _heif_item_get_property_transform_rotation_ccw(_0: number, _1: number, _2: number): number;
  _heif_item_get_property_transform_crop_borders(_0: number, _1: number, _2: number, _3: number, _4: number, _5: number, _6: number, _7: number, _8: number): void;
  _heif_property_user_description_release(_0: number): void;
  _heif_item_add_raw_property(_0: number, _1: number, _2: number, _3: number, _4: number, _5: number, _6: number, _7: number, _8: number): void;
  _heif_item_get_property_raw_size(_0: number, _1: number, _2: number, _3: number, _4: number): void;
  _heif_item_get_property_raw_data(_0: number, _1: number, _2: number, _3: number, _4: number): void;
  _heif_item_get_property_uuid_type(_0: number, _1: number, _2: number, _3: number, _4: number): void;
  _heif_context_get_number_of_items(_0: number): number;
  _heif_context_get_list_of_item_IDs(_0: number, _1: number, _2: number): number;
  _heif_item_get_item_type(_0: number, _1: number): number;
  _heif_item_is_item_hidden(_0: number, _1: number): number;
  _heif_item_get_mime_item_content_type(_0: number, _1: number): number;
  _heif_item_get_mime_item_content_encoding(_0: number, _1: number): number;
  _heif_item_get_uri_item_uri_type(_0: number, _1: number): number;
  _heif_item_get_item_name(_0: number, _1: number): number;
  _heif_item_get_item_data(_0: number, _1: number, _2: number, _3: number, _4: number, _5: number): void;
  _heif_release_item_data(_0: number, _1: number): void;
  _heif_context_get_item_references(_0: number, _1: number, _2: number, _3: number, _4: number): number;
  _heif_release_item_references(_0: number, _1: number): void;
  _heif_context_add_item(_0: number, _1: number, _2: number, _3: number, _4: number, _5: number): void;
  _heif_context_add_mime_item(_0: number, _1: number, _2: number, _3: number, _4: number, _5: number, _6: number): void;
  _heif_context_add_precompressed_mime_item(_0: number, _1: number, _2: number, _3: number, _4: number, _5: number, _6: number): void;
  _heif_context_add_uri_item(_0: number, _1: number, _2: number, _3: number, _4: number, _5: number): void;
  _heif_context_add_item_reference(_0: number, _1: number, _2: number, _3: number, _4: number): void;
  _heif_context_add_item_references(_0: number, _1: number, _2: number, _3: number, _4: number, _5: number): void;
  _heif_item_set_item_name(_0: number, _1: number, _2: number, _3: number): void;
  _de265_get_version(): number;
  _de265_init(): number;
  _de265_free(): number;
  _de265_new_decoder(): number;
  _de265_set_parameter_bool(_0: number, _1: number, _2: number): void;
  _de265_free_decoder(_0: number): number;
  _de265_push_NAL(_0: number, _1: number, _2: number, _3: number, _4: number, _5: number): number;
  _de265_flush_data(_0: number): number;
  _de265_decode(_0: number, _1: number): number;
  _de265_get_next_picture(_0: number): number;
  _de265_get_chroma_format(_0: number): number;
  _de265_get_image_width(_0: number, _1: number): number;
  _de265_get_image_height(_0: number, _1: number): number;
  _de265_get_bits_per_pixel(_0: number, _1: number): number;
  _de265_get_image_plane(_0: number, _1: number, _2: number): number;
  _de265_get_image_colour_primaries(_0: number): number;
  _de265_get_image_transfer_characteristics(_0: number): number;
  _de265_get_image_matrix_coefficients(_0: number): number;
  _de265_get_image_full_range_flag(_0: number): number;
  _de265_release_next_picture(_0: number): void;
}

type EmbindString = ArrayBuffer|Uint8Array|Uint8ClampedArray|Int8Array|string;
export interface heif_error_codeValue<T extends number> {
  value: T;
}
export type heif_error_code = heif_error_codeValue<0>|heif_error_codeValue<1>|heif_error_codeValue<2>|heif_error_codeValue<11>|heif_error_codeValue<3>|heif_error_codeValue<4>|heif_error_codeValue<5>|heif_error_codeValue<6>|heif_error_codeValue<7>|heif_error_codeValue<8>|heif_error_codeValue<9>|heif_error_codeValue<10>|heif_error_codeValue<12>;

export interface heif_suberror_codeValue<T extends number> {
  value: T;
}
export type heif_suberror_code = heif_suberror_codeValue<0>|heif_suberror_codeValue<5000>|heif_suberror_codeValue<1001>|heif_suberror_codeValue<150>|heif_suberror_codeValue<5001>|heif_suberror_codeValue<5002>|heif_suberror_codeValue<5003>|heif_suberror_codeValue<5004>|heif_suberror_codeValue<100>|heif_suberror_codeValue<101>|heif_suberror_codeValue<102>|heif_suberror_codeValue<103>|heif_suberror_codeValue<104>|heif_suberror_codeValue<105>|heif_suberror_codeValue<106>|heif_suberror_codeValue<141>|heif_suberror_codeValue<107>|heif_suberror_codeValue<108>|heif_suberror_codeValue<109>|heif_suberror_codeValue<110>|heif_suberror_codeValue<111>|heif_suberror_codeValue<112>|heif_suberror_codeValue<113>|heif_suberror_codeValue<114>|heif_suberror_codeValue<115>|heif_suberror_codeValue<116>|heif_suberror_codeValue<117>|heif_suberror_codeValue<118>|heif_suberror_codeValue<119>|heif_suberror_codeValue<131>|heif_suberror_codeValue<143>|heif_suberror_codeValue<149>|heif_suberror_codeValue<120>|heif_suberror_codeValue<121>|heif_suberror_codeValue<122>|heif_suberror_codeValue<6001>|heif_suberror_codeValue<6000>|heif_suberror_codeValue<123>|heif_suberror_codeValue<6002>|heif_suberror_codeValue<6003>|heif_suberror_codeValue<124>|heif_suberror_codeValue<125>|heif_suberror_codeValue<1000>|heif_suberror_codeValue<126>|heif_suberror_codeValue<127>|heif_suberror_codeValue<128>|heif_suberror_codeValue<129>|heif_suberror_codeValue<2000>|heif_suberror_codeValue<2001>|heif_suberror_codeValue<2002>|heif_suberror_codeValue<2003>|heif_suberror_codeValue<2004>|heif_suberror_codeValue<2005>|heif_suberror_codeValue<2006>|heif_suberror_codeValue<2007>|heif_suberror_codeValue<2008>|heif_suberror_codeValue<130>|heif_suberror_codeValue<136>|heif_suberror_codeValue<3000>|heif_suberror_codeValue<3001>|heif_suberror_codeValue<3002>|heif_suberror_codeValue<3006>|heif_suberror_codeValue<3007>|heif_suberror_codeValue<3003>|heif_suberror_codeValue<3004>|heif_suberror_codeValue<3005>|heif_suberror_codeValue<4000>|heif_suberror_codeValue<132>|heif_suberror_codeValue<133>|heif_suberror_codeValue<134>|heif_suberror_codeValue<135>|heif_suberror_codeValue<137>|heif_suberror_codeValue<138>|heif_suberror_codeValue<139>|heif_suberror_codeValue<140>|heif_suberror_codeValue<142>;

export interface heif_compression_formatValue<T extends number> {
  value: T;
}
export type heif_compression_format = heif_compression_formatValue<0>|heif_compression_formatValue<1>|heif_compression_formatValue<2>|heif_compression_formatValue<3>|heif_compression_formatValue<4>|heif_compression_formatValue<5>|heif_compression_formatValue<6>|heif_compression_formatValue<7>|heif_compression_formatValue<8>|heif_compression_formatValue<9>|heif_compression_formatValue<10>;

export interface heif_chromaValue<T extends number> {
  value: T;
}
export type heif_chroma = heif_chromaValue<99>|heif_chromaValue<0>|heif_chromaValue<1>|heif_chromaValue<2>|heif_chromaValue<3>|heif_chromaValue<10>|heif_chromaValue<11>|heif_chromaValue<12>|heif_chromaValue<13>|heif_chromaValue<14>|heif_chromaValue<15>|heif_chromaValue<10>|heif_chromaValue<11>;

export interface heif_chroma_downsampling_algorithmValue<T extends number> {
  value: T;
}
export type heif_chroma_downsampling_algorithm = heif_chroma_downsampling_algorithmValue<2>|heif_chroma_downsampling_algorithmValue<1>|heif_chroma_downsampling_algorithmValue<3>;

export interface heif_chroma_upsampling_algorithmValue<T extends number> {
  value: T;
}
export type heif_chroma_upsampling_algorithm = heif_chroma_upsampling_algorithmValue<2>|heif_chroma_upsampling_algorithmValue<1>;

export interface heif_colorspaceValue<T extends number> {
  value: T;
}
export type heif_colorspace = heif_colorspaceValue<99>|heif_colorspaceValue<0>|heif_colorspaceValue<1>|heif_colorspaceValue<2>|heif_colorspaceValue<3>;

export interface heif_channelValue<T extends number> {
  value: T;
}
export type heif_channel = heif_channelValue<0>|heif_channelValue<2>|heif_channelValue<1>|heif_channelValue<3>|heif_channelValue<4>|heif_channelValue<5>|heif_channelValue<6>|heif_channelValue<10>|heif_channelValue<11>|heif_channelValue<12>|heif_channelValue<13>;

export interface heif_filetype_resultValue<T extends number> {
  value: T;
}
export type heif_filetype_result = heif_filetype_resultValue<0>|heif_filetype_resultValue<1>|heif_filetype_resultValue<2>|heif_filetype_resultValue<3>;

export interface heif_context {
  delete(): void;
}

export interface heif_image_handle {
  delete(): void;
}

export interface heif_image {
  delete(): void;
}

export type heif_error = {
  code: heif_error_code,
  subcode: heif_suberror_code,
  message: EmbindString
};

interface EmbindModule {
  heif_error_code: {heif_error_Ok: heif_error_codeValue<0>, heif_error_Input_does_not_exist: heif_error_codeValue<1>, heif_error_Invalid_input: heif_error_codeValue<2>, heif_error_Plugin_loading_error: heif_error_codeValue<11>, heif_error_Unsupported_filetype: heif_error_codeValue<3>, heif_error_Unsupported_feature: heif_error_codeValue<4>, heif_error_Usage_error: heif_error_codeValue<5>, heif_error_Memory_allocation_error: heif_error_codeValue<6>, heif_error_Decoder_plugin_error: heif_error_codeValue<7>, heif_error_Encoder_plugin_error: heif_error_codeValue<8>, heif_error_Encoding_error: heif_error_codeValue<9>, heif_error_Color_profile_does_not_exist: heif_error_codeValue<10>, heif_error_Canceled: heif_error_codeValue<12>};
  heif_suberror_code: {heif_suberror_Unspecified: heif_suberror_codeValue<0>, heif_suberror_Cannot_write_output_data: heif_suberror_codeValue<5000>, heif_suberror_Compression_initialisation_error: heif_suberror_codeValue<1001>, heif_suberror_Decompression_invalid_data: heif_suberror_codeValue<150>, heif_suberror_Encoder_initialization: heif_suberror_codeValue<5001>, heif_suberror_Encoder_encoding: heif_suberror_codeValue<5002>, heif_suberror_Encoder_cleanup: heif_suberror_codeValue<5003>, heif_suberror_Too_many_regions: heif_suberror_codeValue<5004>, heif_suberror_End_of_data: heif_suberror_codeValue<100>, heif_suberror_Invalid_box_size: heif_suberror_codeValue<101>, heif_suberror_No_ftyp_box: heif_suberror_codeValue<102>, heif_suberror_No_idat_box: heif_suberror_codeValue<103>, heif_suberror_No_meta_box: heif_suberror_codeValue<104>, heif_suberror_No_hdlr_box: heif_suberror_codeValue<105>, heif_suberror_No_hvcC_box: heif_suberror_codeValue<106>, heif_suberror_No_vvcC_box: heif_suberror_codeValue<141>, heif_suberror_No_pitm_box: heif_suberror_codeValue<107>, heif_suberror_No_ipco_box: heif_suberror_codeValue<108>, heif_suberror_No_ipma_box: heif_suberror_codeValue<109>, heif_suberror_No_iloc_box: heif_suberror_codeValue<110>, heif_suberror_No_iinf_box: heif_suberror_codeValue<111>, heif_suberror_No_iprp_box: heif_suberror_codeValue<112>, heif_suberror_No_iref_box: heif_suberror_codeValue<113>, heif_suberror_No_pict_handler: heif_suberror_codeValue<114>, heif_suberror_Ipma_box_references_nonexisting_property: heif_suberror_codeValue<115>, heif_suberror_No_properties_assigned_to_item: heif_suberror_codeValue<116>, heif_suberror_No_item_data: heif_suberror_codeValue<117>, heif_suberror_Invalid_grid_data: heif_suberror_codeValue<118>, heif_suberror_Missing_grid_images: heif_suberror_codeValue<119>, heif_suberror_No_av1C_box: heif_suberror_codeValue<131>, heif_suberror_No_avcC_box: heif_suberror_codeValue<143>, heif_suberror_Invalid_mini_box: heif_suberror_codeValue<149>, heif_suberror_Invalid_clean_aperture: heif_suberror_codeValue<120>, heif_suberror_Invalid_overlay_data: heif_suberror_codeValue<121>, heif_suberror_Overlay_image_outside_of_canvas: heif_suberror_codeValue<122>, heif_suberror_Plugin_is_not_loaded: heif_suberror_codeValue<6001>, heif_suberror_Plugin_loading_error: heif_suberror_codeValue<6000>, heif_suberror_Auxiliary_image_type_unspecified: heif_suberror_codeValue<123>, heif_suberror_Cannot_read_plugin_directory: heif_suberror_codeValue<6002>, heif_suberror_No_matching_decoder_installed: heif_suberror_codeValue<6003>, heif_suberror_No_or_invalid_primary_item: heif_suberror_codeValue<124>, heif_suberror_No_infe_box: heif_suberror_codeValue<125>, heif_suberror_Security_limit_exceeded: heif_suberror_codeValue<1000>, heif_suberror_Unknown_color_profile_type: heif_suberror_codeValue<126>, heif_suberror_Wrong_tile_image_chroma_format: heif_suberror_codeValue<127>, heif_suberror_Invalid_fractional_number: heif_suberror_codeValue<128>, heif_suberror_Invalid_image_size: heif_suberror_codeValue<129>, heif_suberror_Nonexisting_item_referenced: heif_suberror_codeValue<2000>, heif_suberror_Null_pointer_argument: heif_suberror_codeValue<2001>, heif_suberror_Nonexisting_image_channel_referenced: heif_suberror_codeValue<2002>, heif_suberror_Unsupported_plugin_version: heif_suberror_codeValue<2003>, heif_suberror_Unsupported_writer_version: heif_suberror_codeValue<2004>, heif_suberror_Unsupported_parameter: heif_suberror_codeValue<2005>, heif_suberror_Invalid_parameter_value: heif_suberror_codeValue<2006>, heif_suberror_Invalid_property: heif_suberror_codeValue<2007>, heif_suberror_Item_reference_cycle: heif_suberror_codeValue<2008>, heif_suberror_Invalid_pixi_box: heif_suberror_codeValue<130>, heif_suberror_Invalid_region_data: heif_suberror_codeValue<136>, heif_suberror_Unsupported_codec: heif_suberror_codeValue<3000>, heif_suberror_Unsupported_image_type: heif_suberror_codeValue<3001>, heif_suberror_Unsupported_data_version: heif_suberror_codeValue<3002>, heif_suberror_Unsupported_generic_compression_method: heif_suberror_codeValue<3006>, heif_suberror_Unsupported_essential_property: heif_suberror_codeValue<3007>, heif_suberror_Unsupported_color_conversion: heif_suberror_codeValue<3003>, heif_suberror_Unsupported_item_construction_method: heif_suberror_codeValue<3004>, heif_suberror_Unsupported_header_compression_method: heif_suberror_codeValue<3005>, heif_suberror_Unsupported_bit_depth: heif_suberror_codeValue<4000>, heif_suberror_Wrong_tile_image_pixel_depth: heif_suberror_codeValue<132>, heif_suberror_Unknown_NCLX_color_primaries: heif_suberror_codeValue<133>, heif_suberror_Unknown_NCLX_transfer_characteristics: heif_suberror_codeValue<134>, heif_suberror_Unknown_NCLX_matrix_coefficients: heif_suberror_codeValue<135>, heif_suberror_No_ispe_property: heif_suberror_codeValue<137>, heif_suberror_Camera_intrinsic_matrix_undefined: heif_suberror_codeValue<138>, heif_suberror_Camera_extrinsic_matrix_undefined: heif_suberror_codeValue<139>, heif_suberror_Invalid_J2K_codestream: heif_suberror_codeValue<140>, heif_suberror_No_icbr_box: heif_suberror_codeValue<142>};
  heif_compression_format: {heif_compression_undefined: heif_compression_formatValue<0>, heif_compression_HEVC: heif_compression_formatValue<1>, heif_compression_AVC: heif_compression_formatValue<2>, heif_compression_JPEG: heif_compression_formatValue<3>, heif_compression_AV1: heif_compression_formatValue<4>, heif_compression_VVC: heif_compression_formatValue<5>, heif_compression_EVC: heif_compression_formatValue<6>, heif_compression_JPEG2000: heif_compression_formatValue<7>, heif_compression_uncompressed: heif_compression_formatValue<8>, heif_compression_mask: heif_compression_formatValue<9>, heif_compression_HTJ2K: heif_compression_formatValue<10>};
  heif_chroma: {heif_chroma_undefined: heif_chromaValue<99>, heif_chroma_monochrome: heif_chromaValue<0>, heif_chroma_420: heif_chromaValue<1>, heif_chroma_422: heif_chromaValue<2>, heif_chroma_444: heif_chromaValue<3>, heif_chroma_interleaved_RGB: heif_chromaValue<10>, heif_chroma_interleaved_RGBA: heif_chromaValue<11>, heif_chroma_interleaved_RRGGBB_BE: heif_chromaValue<12>, heif_chroma_interleaved_RRGGBBAA_BE: heif_chromaValue<13>, heif_chroma_interleaved_RRGGBB_LE: heif_chromaValue<14>, heif_chroma_interleaved_RRGGBBAA_LE: heif_chromaValue<15>, heif_chroma_interleaved_24bit: heif_chromaValue<10>, heif_chroma_interleaved_32bit: heif_chromaValue<11>};
  heif_chroma_downsampling_algorithm: {heif_chroma_downsampling_average: heif_chroma_downsampling_algorithmValue<2>, heif_chroma_downsampling_nearest_neighbor: heif_chroma_downsampling_algorithmValue<1>, heif_chroma_downsampling_sharp_yuv: heif_chroma_downsampling_algorithmValue<3>};
  heif_chroma_upsampling_algorithm: {heif_chroma_upsampling_bilinear: heif_chroma_upsampling_algorithmValue<2>, heif_chroma_upsampling_nearest_neighbor: heif_chroma_upsampling_algorithmValue<1>};
  heif_colorspace: {heif_colorspace_undefined: heif_colorspaceValue<99>, heif_colorspace_YCbCr: heif_colorspaceValue<0>, heif_colorspace_RGB: heif_colorspaceValue<1>, heif_colorspace_monochrome: heif_colorspaceValue<2>, heif_colorspace_nonvisual: heif_colorspaceValue<3>};
  heif_channel: {heif_channel_Y: heif_channelValue<0>, heif_channel_Cr: heif_channelValue<2>, heif_channel_Cb: heif_channelValue<1>, heif_channel_R: heif_channelValue<3>, heif_channel_G: heif_channelValue<4>, heif_channel_B: heif_channelValue<5>, heif_channel_Alpha: heif_channelValue<6>, heif_channel_interleaved: heif_channelValue<10>, heif_channel_filter_array: heif_channelValue<11>, heif_channel_depth: heif_channelValue<12>, heif_channel_disparity: heif_channelValue<13>};
  heif_filetype_result: {heif_filetype_no: heif_filetype_resultValue<0>, heif_filetype_yes_supported: heif_filetype_resultValue<1>, heif_filetype_yes_unsupported: heif_filetype_resultValue<2>, heif_filetype_maybe: heif_filetype_resultValue<3>};
  heif_context: {};
  heif_context_alloc(): heif_context;
  heif_image_handle: {};
  heif_image: {};
  heif_context_free(_0: heif_context): void;
  heif_image_handle_release(_0: heif_image_handle): void;
  heif_image_release(_0: heif_image): void;
  heif_context_get_number_of_top_level_images(_0: heif_context): number;
  heif_image_handle_get_width(_0: heif_image_handle): number;
  heif_image_handle_get_height(_0: heif_image_handle): number;
  heif_image_handle_is_primary_image(_0: heif_image_handle): number;
  heif_get_version_number(): number;
  heif_get_version(): string;
  heif_js_check_filetype(_0: EmbindString): heif_filetype_result;
  heif_context_read_from_memory(_0: heif_context, _1: EmbindString): heif_error;
  heif_js_context_get_list_of_top_level_image_IDs(_0: heif_context): any;
  heif_js_context_get_image_handle(_0: heif_context, _1: number): any;
  heif_js_context_get_primary_image_handle(_0: heif_context): any;
  heif_js_decode_image2(_0: heif_image_handle, _1: heif_colorspace, _2: heif_chroma): any;
}

export type MainModule = WasmModule & typeof RuntimeExports & EmbindModule;
export default function MainModuleFactory (options?: unknown): MainModule;
