# Class for manipulating Ruby's garbage collection during testing to speed up tests
# Code taken from http://railscasts.com/episodes/413-fast-tests
class DeferredGarbageCollection

    DEFERRED_GC_THRESHOLD = (ENV['DEFER_GC'] || 15.0).to_f
  
    @@last_gc_run = Time.now
  
    def self.start
      GC.disable if DEFERRED_GC_THRESHOLD > 0
    end
  
    def self.reconsider
      if DEFERRED_GC_THRESHOLD > 0 && Time.now - @@last_gc_run >= DEFERRED_GC_THRESHOLD
        GC.enable
        GC.start
        GC.disable
        @@last_gc_run = Time.now
      end
    end
  end
  
  