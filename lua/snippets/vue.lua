local vc = s(
  'vc',
  fmt(
    [[
<script setup lang="ts">
  {}
</script>

<template>
  <div>{}</div>
</template>
]],
    {
      i(1),
      i(0),
    }
  )
)

return {
  vc,
}
