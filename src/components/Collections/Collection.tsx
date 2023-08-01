import {
  ActionIcon,
  AspectRatio,
  Box,
  Center,
  ContainerProps,
  Group,
  Stack,
  Text,
  ThemeIcon,
  Title,
  Tooltip,
} from '@mantine/core';
import { CollectionType } from '@prisma/client';
import { IconCirclePlus, IconCloudOff, IconDotsVertical } from '@tabler/icons-react';
import { useState } from 'react';
import { ArticlesInfinite } from '~/components/Article/Infinite/ArticlesInfinite';
import { useArticleQueryParams } from '~/components/Article/article.utils';
import { CategoryTags } from '~/components/CategoryTags/CategoryTags';
import { AddUserContentModal } from '~/components/Collections/AddUserContentModal';
import { CollectionContextMenu } from '~/components/Collections/components/CollectionContextMenu';
import { CollectionFollowAction } from '~/components/Collections/components/CollectionFollow';
import { EdgeImage } from '~/components/EdgeImage/EdgeImage';
import { PeriodFilter, SortFilter } from '~/components/Filters';
import ImagesInfinite from '~/components/Image/Infinite/ImagesInfinite';
import { useImageQueryParams } from '~/components/Image/image.utils';
import { IsClient } from '~/components/IsClient/IsClient';
import { MasonryContainer } from '~/components/MasonryColumns/MasonryContainer';
import { MasonryProvider } from '~/components/MasonryColumns/MasonryProvider';
import { ModelFiltersDropdown } from '~/components/Model/Infinite/ModelFiltersDropdown';
import { ModelsInfinite } from '~/components/Model/Infinite/ModelsInfinite';
import { useModelQueryParams } from '~/components/Model/model.utils';
import PostsInfinite from '~/components/Post/Infinite/PostsInfinite';
import { usePostQueryParams } from '~/components/Post/post.utils';
import { UserAvatar } from '~/components/UserAvatar/UserAvatar';
import { constants } from '~/server/common/constants';
import { CollectionByIdModel } from '~/types/router';
import { trpc } from '~/utils/trpc';

const ModelCollection = ({ collection }: { collection: NonNullable<CollectionByIdModel> }) => {
  const { set, ...queryFilters } = useModelQueryParams();

  return (
    <Stack spacing="xs">
      <IsClient>
        <Group position="apart" spacing={0}>
          <Group>
            <SortFilter type="models" />
          </Group>
          <Group spacing={4}>
            <PeriodFilter type="models" />
            <ModelFiltersDropdown />
          </Group>
        </Group>
        <CategoryTags />
        <ModelsInfinite
          filters={{
            ...queryFilters,
            collectionId: collection.id,
          }}
        />
      </IsClient>
    </Stack>
  );
};

const ImageCollection = ({ collection }: { collection: NonNullable<CollectionByIdModel> }) => {
  const { ...queryFilters } = useImageQueryParams();

  return (
    <Stack spacing="xs">
      <IsClient>
        <Group position="apart" spacing={0}>
          <Group>
            <SortFilter type="images" />
          </Group>
          <Group spacing={4}>
            <PeriodFilter type="images" />
          </Group>
        </Group>
        <CategoryTags />
        <ImagesInfinite
          filters={{
            ...queryFilters,
            collectionId: collection.id,
          }}
          withTags
        />
      </IsClient>
    </Stack>
  );
};
const PostCollection = ({ collection }: { collection: NonNullable<CollectionByIdModel> }) => {
  const { set, ...queryFilters } = usePostQueryParams();

  return (
    <Stack spacing="xs">
      <IsClient>
        <Group position="apart" spacing={0}>
          <Group>
            <SortFilter type="posts" />
          </Group>
          <Group spacing={4}>
            <PeriodFilter type="posts" />
          </Group>
        </Group>
        <CategoryTags />
        <PostsInfinite
          filters={{
            ...queryFilters,
            collectionId: collection.id,
          }}
        />
      </IsClient>
    </Stack>
  );
};

const ArticleCollection = ({ collection }: { collection: NonNullable<CollectionByIdModel> }) => {
  const { set, ...queryFilters } = useArticleQueryParams();

  return (
    <Stack spacing="xs">
      <IsClient>
        <Group position="apart" spacing={0}>
          <Group>
            <SortFilter type="articles" />
          </Group>
          <Group spacing={4}>
            <PeriodFilter type="articles" />
          </Group>
        </Group>
        <CategoryTags />
        <ArticlesInfinite
          filters={{
            ...queryFilters,
            collectionId: collection.id,
          }}
        />
      </IsClient>
    </Stack>
  );
};

export function Collection({
  collectionId,
  ...containerProps
}: { collectionId: number } & Omit<ContainerProps, 'children'>) {
  const [opened, setOpened] = useState(false);

  const { data: { collection, permissions } = {}, isLoading } = trpc.collection.getById.useQuery({
    id: collectionId,
  });

  if (!isLoading && !collection) {
    return (
      <Stack w="100%" align="center">
        <Stack spacing="md" align="center" maw={800}>
          <Title order={1} inline>
            Whoops!
          </Title>
          <Text align="center">
            It looks like you landed on the wrong place.The collection you are trying to access does
            not exist or you do not have the sufficient permissions to see it.
          </Text>
          <ThemeIcon size={128} radius={100} sx={{ opacity: 0.5 }}>
            <IconCloudOff size={80} />
          </ThemeIcon>
        </Stack>
      </Stack>
    );
  }

  const collectionType = collection?.type;
  // TODO.collections: This is tied to images for now but
  // we will need to add a check for other resources later
  const canAddContent =
    collectionType === CollectionType.Image && (permissions?.write || permissions?.writeReview);

  return (
    <>
      <MasonryProvider
        columnWidth={constants.cardSizes.model}
        maxColumnCount={7}
        maxSingleColumnWidth={450}
      >
        <MasonryContainer {...containerProps} p={0}>
          <Stack spacing="xl" w="100%">
            <Group spacing="xl">
              {collection?.image && (
                <Box
                  w={220}
                  sx={(theme) => ({
                    overflow: 'hidden',
                    borderRadius: '8px',
                    boxShadow: theme.shadows.md,
                    [theme.fn.smallerThan('sm')]: { width: '100%', marginBottom: theme.spacing.xs },
                  })}
                >
                  <AspectRatio ratio={1}>
                    <EdgeImage
                      src={collection.image.url}
                      name={collection.image.name ?? collection.image.url}
                      alt={collection.image.name ?? undefined}
                      width={collection.image.width ?? 1200}
                      placeholder="empty"
                      loading="lazy"
                    />
                  </AspectRatio>
                </Box>
              )}
              <Stack spacing={8} sx={{ flex: 1 }}>
                <Stack spacing={0}>
                  <Title
                    order={1}
                    lineClamp={1}
                    sx={(theme) => ({
                      [theme.fn.smallerThan('sm')]: {
                        fontSize: '28px',
                      },
                    })}
                  >
                    {collection?.name ?? 'Loading...'}
                  </Title>
                  {collection?.description && (
                    <Text size="xs" color="dimmed">
                      {collection.description}
                    </Text>
                  )}
                </Stack>
                {collection && (
                  <Group spacing={4} noWrap>
                    <UserAvatar user={collection.user} withUsername linkToProfile />
                    {/* TODO.collections: We need some metrics to actually display these badges */}
                    {/* <IconBadge className={classes.iconBadge} icon={<IconLayoutGrid size={14} />}>
                      <Text size="xs">{abbreviateNumber(data._count.items)}</Text>
                    </IconBadge>
                    <IconBadge className={classes.iconBadge} icon={<IconUser size={14} />}>
                      <Text size="xs">{abbreviateNumber(data._count.contributors)}</Text>
                    </IconBadge> */}
                  </Group>
                )}
              </Stack>
              {collection && permissions && (
                <Group spacing={4} ml="auto" sx={{ alignSelf: 'flex-start' }} noWrap>
                  <CollectionFollowAction collection={collection} permissions={permissions} />
                  {canAddContent && (
                    <Tooltip label="Add from your library" position="bottom" withArrow>
                      <ActionIcon
                        color="blue"
                        variant="subtle"
                        radius="xl"
                        onClick={() => setOpened(true)}
                      >
                        <IconCirclePlus />
                      </ActionIcon>
                    </Tooltip>
                  )}
                  <CollectionContextMenu
                    collectionId={collection.id}
                    ownerId={collection.user.id}
                    permissions={permissions}
                  >
                    <ActionIcon variant="subtle">
                      <IconDotsVertical size={16} />
                    </ActionIcon>
                  </CollectionContextMenu>
                </Group>
              )}
            </Group>
            {collection && collectionType === CollectionType.Model && (
              <ModelCollection collection={collection} />
            )}
            {collection && collectionType === CollectionType.Image && (
              <ImageCollection collection={collection} />
            )}
            {collection && collectionType === CollectionType.Post && (
              <PostCollection collection={collection} />
            )}
            {collection && collectionType === CollectionType.Article && (
              <ArticleCollection collection={collection} />
            )}
            {!collectionType && !isLoading && (
              <Center py="xl">
                <Stack spacing="xs">
                  <Text size="lg" weight="700" align="center">
                    Whoops!
                  </Text>
                  <Text align="center">This collection type is not supported</Text>
                </Stack>
              </Center>
            )}
          </Stack>
        </MasonryContainer>
      </MasonryProvider>
      {collection && canAddContent && (
        <AddUserContentModal
          collectionId={collection.id}
          opened={opened}
          onClose={() => setOpened(false)}
        />
      )}
    </>
  );
}
