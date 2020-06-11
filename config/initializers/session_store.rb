Rails.application.config.session_store :active_record_store, key: (Rails.env.production? ? '_training1_session_id' : (Rails.env.demo? ? '_training1_demo_session_id' : '_training1_dev_session_id')),
                                                             secure: (Rails.env.demo? || Rails.env.production?),
                                                             httponly: true
