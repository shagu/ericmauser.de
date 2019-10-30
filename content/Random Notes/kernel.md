# Linux Kernel
## suspend to memory

    echo -n mem > /sys/power/state

### Enable it for users

in ./kernel/power/power.h:70 change "mode = 0644" to:

    #define power_attr(_name) \
    static struct kobj_attribute _name##_attr = {   \
            .attr   = {                             \
                    .name = __stringify(_name),     \
                    .mode = 0777,                   \
            },                                      \
            .show   = _name##_show,                 \
            .store  = _name##_store,                \
    }
